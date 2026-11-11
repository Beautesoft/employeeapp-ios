//
//  AppDelegate+Navigation.swift
//  App27 Hub
//
//  Created by Himanshu Singla on 05/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit
import SWRevealViewController
extension AppDelegate {
    func makeRoot(viewController: UIViewController, navigationBarHidden value: Bool) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = value
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func gotoLogin() {
        let loginVC = LoginVC.instantiateFrom(storyboard: .prelogin)
        AppDelegate.shared.makeRoot(viewController: loginVC, navigationBarHidden: true)
    }
    
    func gotoHome(){
        let revealController = Storyboards.homeflow.instance.instantiateViewController(withIdentifier: Identifiers.SWRevealViewController.rawValue) as! SWRevealViewController
        AppDelegate.shared.makeRoot(viewController: revealController, navigationBarHidden: true)
    }
    
    func checkForNavigation() {
        if let dictionary =  UserDefaultsManager.profile {
            profile = Profile(fromDictionary: dictionary)
            BaseURLResolver.restoreSaved()
            if BaseURLResolver.hasValidSavedBaseUrl {
                gotoHome()
            } else {
                // Logged in, but no usable server saved (e.g. upgraded from v3.4, which saved
                // the retired default server). Resolve it before Home fires any API calls.
                showLaunchPlaceholder()
                BaseURLResolver.refreshForLoggedInUser { success in
                    if success {
                        self.gotoHome()
                    } else {
                        // Could not resolve (offline / code removed): back to Login. Logging in
                        // again re-runs the lookup and shows a specific error if it still fails.
                        self.logout()
                    }
                }
            }
        } else {
            gotoLogin()
        }
    }
    
    private func showLaunchPlaceholder() {
        let placeholder = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() ?? UIViewController()
        if placeholder.view.backgroundColor == nil { placeholder.view.backgroundColor = .white }
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        placeholder.view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: placeholder.view.centerXAnchor),
            spinner.bottomAnchor.constraint(equalTo: placeholder.view.bottomAnchor, constant: -80)
        ])
        window?.rootViewController = placeholder
        window?.makeKeyAndVisible()
    }

    func logout() {
        UserDefaultsManager.resetDefaults()
        profile = Profile()
        AppDelegate.shared.gotoLogin()
    }
}
