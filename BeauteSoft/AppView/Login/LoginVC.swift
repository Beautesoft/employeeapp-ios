//
//  LoginVC.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//
import Firebase
import UIKit
var profile = Profile()
class LoginVC: UIViewController {

    @IBOutlet weak var txtLocale: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    private let loginBL = LoginBL()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnShowPassword.isSelected = false
        txtPassword.isSecureTextEntry =  true
    }
    
    @IBAction func btnShowHidePasswordClicked(_ sender: Any) {
        btnShowPassword.isSelected = !btnShowPassword.isSelected
        if btnShowPassword.isSelected {
            txtPassword.isSecureTextEntry =  false
        }else {
            txtPassword.isSecureTextEntry =  true
        }
    }
    @IBAction func actionLogin(_ sender: UIButton) {
        if txtUsername.isBlank {
            self.singleButtonAlertWith(message: Messages.emailPlease)
        } else if txtPassword.text!.isEmpty {
            self.singleButtonAlertWith(message: Messages.enterPass)
        } else if txtLocale.isBlank {
            self.singleButtonAlertWith(message: Messages.enterLocale)
        } else {
            //Yoonus
            //base = "http://103.253.14.203/main/api/"
            getLocaleBaseURL(name: txtLocale.trimmedText.uppercased()) { baseUrl in
                       if let baseUrl = baseUrl {
                           // Use the retrieved base URL
                           base = baseUrl
                           baseDashboard = baseUrl
                           self.login()
                       } else {
                           // Handle error or no data case
                           self.singleButtonAlertWith(message: Messages.firebaseRetrieveBaseURLError)
                       }
                   }
            UserDefaults.standard.set(base, forKey: "base") //setObject
            UserDefaults.standard.set(txtLocale.trimmedText.uppercased(), forKey: "locale") //setObject
            //
             
        }
       
    }
    
    @IBAction func actionForgotpassword(_ sender: UIButton) {
        let forgotPasswordVC = ForgotPasswordVC.instantiateFrom(storyboard: .prelogin)
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @IBAction func actionPribvacyPolicy(_ sender: UIButton) {
        let termsVC = TermsConditionVC.instantiateFrom(storyboard: .prelogin)
        termsVC.page = .privacyPolicy
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @IBAction func actionTermsConditions(_ sender: UIButton) {
        let termsVC = TermsConditionVC.instantiateFrom(storyboard: .prelogin)
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    func login() {
        let params = ["userID": txtUsername.trimmedText,
                      "email": txtUsername.trimmedText,
                      "password": txtPassword.text!,
                      "companyCode": txtLocale.trimmedText]
        loginBL.login(params: params) {
            UserDefaultsManager.userId = self.txtUsername.trimmedText
            UserDefaultsManager.locale = self.txtLocale.trimmedText
            UserDefaultsManager.password = self.txtPassword.trimmedText
            AppDelegate.shared.gotoHome()
        }
    }
    func getLocaleBaseURL(name: String, completion: @escaping (String?) -> Void) {
           // Create a reference to the Firebase database
           let databaseReference = Database.database().reference()
           // Read the JSON data
           databaseReference.child("ClientUrls").observeSingleEvent(of: .value) { (snapshot) in
               if let value = snapshot.value as? [String: Any] {
                   for (key, data) in value {
                       if key == name, let aesData = data as? [String: Any] {
                           if let baseUrl = aesData["Baseurl"] as? String {
                               completion(baseUrl)
                               return
                           }
                       }
                   }
               } else {
                   print("Error: Invalid JSON format")
                   completion(nil)
               }
           }
       }
}
