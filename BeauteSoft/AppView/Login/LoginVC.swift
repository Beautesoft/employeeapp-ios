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
            /*
            if txtLocale.trimmedText.uppercased() == "TNCDEMO" {
                base = "http://103.253.15.102:88/main_api/api/"
                baseDashboard = "http://103.253.15.102:88/main_api/api/"
            } else if (txtLocale.trimmedText.uppercased() == "DEMO"){
                base = "http://103.253.14.203/main/api/"
                baseDashboard = "http://103.253.14.203/main/api/"}
            else if (txtLocale.trimmedText.uppercased() == "BEAUTY"){
                base = "http://118.189.74.184/beauty/api/"
                baseDashboard = "http://118.189.74.184/beauty/api/"}
            else if (txtLocale.trimmedText.uppercased() == "OHS"){
                base = "http://118.189.74.184/ohs/api/"
                baseDashboard = "http://118.189.74.184/ohs/api/"}
            else if (txtLocale.trimmedText.uppercased() == "OHC"){
                base = "http://originida.ddns.net:8686/main/api/"
                baseDashboard = "http://originida.ddns.net:8686/main/api/"}
            else if (txtLocale.trimmedText.uppercased() == "TNC"){
                base = "http://103.253.15.102:88/cloudtncapi/api/"
                baseDashboard = "http://103.253.15.102:88/cloudtncapi/api"}
            else if (txtLocale.trimmedText.uppercased() == "TNCOLD"){
                base = "http://tncbeautysg.ddns.net:88/main/api/"
                baseDashboard = "http://tncbeautysg.ddns.net:88/main/api/"}
            else if (txtLocale.trimmedText.uppercased() == "FOREVER"){
                base = "http://beautyforeverhq.ddns.net:88/main/api/"
                baseDashboard = "http://beautyforeverhq.ddns.net:88/main/api/"}
            else if (txtLocale.trimmedText.uppercased() == "F21"){
                base = "http://21feblous.ddns.net:8080/main/api/"
                baseDashboard = "http://21feblous.ddns.net:8080/main/api/"}
            else if (txtLocale.trimmedText.uppercased() == "DEMO1"){
                base = "http://103.253.15.74/demo/api/"
                baseDashboard = "http://103.253.15.74/demo/api/"}
            else if (txtLocale.trimmedText.uppercased() == "DEMO2"){
                base = "http://103.253.15.76/demo/api/"
                baseDashboard = "http://103.253.15.76/demo/api/"}
            else if (txtLocale.trimmedText.uppercased() == "DEMO3"){
                base = "http://103.253.15.102/demo/api/"
                baseDashboard = "http://103.253.15.102/demo/api/"}
            else if (txtLocale.trimmedText.uppercased() == "SKINCLOUD"){
                base = "http://sequoiasg.ddns.net:7010/main_api/api/"
                baseDashboard = "http://sequoiasg.ddns.net:7010/main_api/api/"}
            else if (txtLocale.trimmedText.uppercased() == "SKINCLOUDOLD"){
                base = "http://103.253.15.73:8489/Main_API/api/"
                baseDashboard = "http://103.253.15.73:8489/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ESTH"){
                base = "http://103.253.15.102:9399/Main_API/api/"
                baseDashboard = "http://103.253.15.102:9399/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ESTHOLD"){
                base = "http://103.253.15.73:8080/mainesth/api/"
                baseDashboard = "http://103.253.15.73:8080/mainesth/api/"}
            else if (txtLocale.trimmedText.uppercased() == "BEST"){
                base = "http://103.253.15.75:9596/mainapi/api/"
                baseDashboard = "http://103.253.15.75:9596/mainapi/api/"}
            else if (txtLocale.trimmedText.uppercased() == "CUTTOUR"){
                base = "http://sequoiasg.ddns.net:7014/mainapi/api/"
                baseDashboard = "http://sequoiasg.ddns.net:7014/mainapi/api/"}
            else if (txtLocale.trimmedText.uppercased() == "MARMA"){
                base = "https://crm.soha.edu.sg/apimarmaclinic/api/"
                baseDashboard = "https://crm.soha.edu.sg/apimarmaclinic/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ELVA"){
                base = "http://103.253.14.203:4004/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4004/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "SYNTHESIS"){
                base = "http://103.253.14.203:4005/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4005/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "EMMABELLE"){
                base = "http://103.253.15.102:9592/Main_api/api/"
                baseDashboard = "http://103.253.15.102:9592/Main_api/api/"}
            else if (txtLocale.trimmedText.uppercased() == "MAGICION"){
                base = "http://103.253.14.203:4006/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4006/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "CITI"){
                base = "http://103.253.14.203:4011/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4011/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ETERNAL"){
                base = "http://103.253.14.203:4020/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4020/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "IMPRESSION"){
                base = "http://103.253.15.102:9591/Main_API/api/"
                baseDashboard = "http://103.253.15.102:9591/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "EMBRACE"){
                           base = "http://103.253.14.203:4015/Main_API/api/"
                           baseDashboard = "http://103.253.14.203:4015/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ESSENTIALS"){
                           base = "http://103.253.15.102:9599/Main_API/api/"
                           baseDashboard = "http://103.253.15.102:9599/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "SLBEAUTY"){
                           base = "http://103.253.15.102:9595/Main_API/api/"
                           baseDashboard = "http://103.253.15.102:9595/Main_API/api/"}
            else {
                base = "http://103.253.14.203/main/api/"
                baseDashboard = "http://103.253.14.203/main/api/"}
            */

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
