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
            gotoHome()
        } else {
            gotoLogin()
        }
    }
    
    func logout() {
        UserDefaultsManager.resetDefaults()
        profile = Profile()
        AppDelegate.shared.gotoLogin()
    }
}
