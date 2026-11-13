//
//  AppDelegate.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SWRevealViewController
import Firebase
import FirebaseCore
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        window = UIWindow(frame: UIScreen.main.bounds)
        checkForNavigation()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // 1. Restore the last known-good server immediately so the UI can work offline-first.
        BaseURLResolver.restoreSaved()
        // 2. Then re-check Firebase for the logged-in company, so a server move done in
        //    Firebase reaches already-logged-in users without them having to log out.
        BaseURLResolver.refreshForLoggedInUser()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


// MARK: - Base URL resolution (Firebase ClientUrls)

/// Resolves and persists the per-company API base URL.
///
/// Source of truth: Firebase Realtime Database `ClientUrls/<COMPANYCODE>/Baseurl`
/// (the same node the Android app reads).
enum BaseURLResolver {

    enum ResolveError: Error {
        case notFound          // company code missing in Firebase
        case invalidUrl        // Baseurl present but not a usable http(s) URL
        case unavailable       // Firebase read cancelled / denied
        case timeout           // no answer (e.g. offline) within `timeoutSeconds`

        func userMessage(companyCode: String) -> String {
            switch self {
            case .notFound:
                return "Company code \"\(companyCode)\" was not found. Please check the company code and try again."
            case .invalidUrl:
                return "The server address configured for \"\(companyCode)\" is invalid. Please contact support."
            case .unavailable, .timeout:
                return "Unable to reach the configuration server. Please check your internet connection and try again."
            }
        }
    }

    private static let baseKey = "base"
    private static let timeoutSeconds: TimeInterval = 15

    /// Servers that are permanently offline. A saved value pointing at one of these
    /// (written by app versions <= 3.4) must never be restored.
    private static let retiredBaseUrls: Set<String> = [
        "http://103.253.14.203/main/api/"
    ]

    private static var isRefreshing = false
    private static var pendingRefreshCompletions: [(Bool) -> Void] = []

    /// Looks up the base URL for `companyCode`. Completion is always called exactly once, on the main queue.
    static func resolve(companyCode: String, completion: @escaping (Result<String, ResolveError>) -> Void) {
        let code = companyCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var finished = false
        let finish: (Result<String, ResolveError>) -> Void = { result in
            DispatchQueue.main.async {
                guard !finished else { return }
                finished = true
                completion(result)
            }
        }

        // Firebase keys cannot contain . # $ [ ] / ; such a code can never exist.
        guard !code.isEmpty, code.rangeOfCharacter(from: CharacterSet(charactersIn: ".#$[]/")) == nil else {
            finish(.failure(.notFound))
            return
        }

        // observeSingleEvent waits forever while offline, so enforce a timeout.
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutSeconds) {
            finish(.failure(.timeout))
        }

        Database.database().reference()
            .child("ClientUrls").child(code).child("Baseurl")
            .observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists(), let raw = snapshot.value as? String else {
                    finish(.failure(.notFound))
                    return
                }
                guard let url = normalize(raw) else {
                    finish(.failure(.invalidUrl))
                    return
                }
                finish(.success(url))
            }, withCancel: { _ in
                finish(.failure(.unavailable))
            })
    }

    /// Activates and persists a resolved URL.
    static func apply(baseUrl: String, companyCode: String) {
        base = baseUrl
        baseDashboard = baseUrl
        UserDefaults.standard.set(baseUrl, forKey: baseKey)
        // Note: the company code itself is stored by LoginVC.login() exactly as typed
        // (AttendanceVC compares it case-sensitively), so it is not overwritten here.
    }

    /// True when a usable, non-retired URL has been persisted.
    static var hasValidSavedBaseUrl: Bool {
        guard let saved = UserDefaults.standard.string(forKey: baseKey),
              let url = normalize(saved) else { return false }
        return !retiredBaseUrls.contains(url)
    }

    /// Restores the persisted URL unless it is empty or a retired server.
    static func restoreSaved() {
        guard let saved = UserDefaults.standard.string(forKey: baseKey),
              let url = normalize(saved) else { return }
        if retiredBaseUrls.contains(url) {
            UserDefaults.standard.removeObject(forKey: baseKey)
            return
        }
        base = url
        baseDashboard = url
    }

    /// For a logged-in user, silently re-reads Firebase and updates the URL if it changed.
    /// Failures are ignored here (the restored URL keeps being used).
    /// `completion(true)` when a URL was resolved and applied.
    static func refreshForLoggedInUser(completion: ((Bool) -> Void)? = nil) {
        guard UserDefaultsManager.profile != nil,
              let code = UserDefaultsManager.locale, !code.isEmpty else {
            completion?(false)
            return
        }
        if let completion = completion { pendingRefreshCompletions.append(completion) }
        guard !isRefreshing else { return }   // join the lookup already in flight
        isRefreshing = true
        resolve(companyCode: code) { result in
            isRefreshing = false
            var ok = false
            if case .success(let url) = result {
                apply(baseUrl: url, companyCode: code)
                ok = true
            }
            let callbacks = pendingRefreshCompletions
            pendingRefreshCompletions.removeAll()
            callbacks.forEach { $0(ok) }
        }
    }

    /// Trims whitespace, requires http(s) and a host, and guarantees a trailing "/"
    /// (endpoints are appended as base + "login", etc.).
    static func normalize(_ raw: String) -> String? {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let comps = URLComponents(string: s),
              let scheme = comps.scheme?.lowercased(), scheme == "http" || scheme == "https",
              let host = comps.host, !host.isEmpty else { return nil }
        if !s.hasSuffix("/") { s += "/" }
        return s
    }
}
