//
//  LoginVC.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

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
                base = "http://103.253.14.203:4001/main_api/"
                baseDashboard = "http://103.253.14.203:4001/main_api/"}
            else if (txtLocale.trimmedText.uppercased() == "TNCOLD"){
                base = "http://103.253.15.102:88/cloudtncapi/api/"
                baseDashboard = "http://103.253.15.102:88/cloudtncapi/api"}
                //base = "http://tncbeautysg.ddns.net:88/main/api/"
                //baseDashboard = "http://tncbeautysg.ddns.net:88/main/api/"}
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
                base = "http://103.253.14.203:4002/main_api/"
                baseDashboard = "http://103.253.14.203:4002/main_api/"}
            else if (txtLocale.trimmedText.uppercased() == "SKINCLOUDOLD"){
                base = "http://sequoiasg.ddns.net:7010/main_api/api/"
                baseDashboard = "http://sequoiasg.ddns.net:7010/main_api/api/"}
                //base = "http://103.253.15.73:8489/Main_API/api/"
                //baseDashboard = "http://103.253.15.73:8489/Main_API/api/"}
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
                base = "http://103.253.14.203:4003/Main_API/"
                baseDashboard = "http://103.253.14.203:4003/Main_API/"}
            else if (txtLocale.trimmedText.uppercased() == "ELVA"){
                base = "http://103.253.14.203:4004/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4004/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "SYNTHESIS"){
                base = "http://103.253.14.203:4005/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4005/Main_API/api/"}
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
                base = "http://103.253.14.203:4015/Main_API/"
                baseDashboard = "http://103.253.14.203:4015/Main_API/"}
            else if (txtLocale.trimmedText.uppercased() == "MYDEMO"){
                base = "http://103.253.14.203:4029/mainapi/"
                baseDashboard = "http://103.253.14.203:4029/mainapi/"}
            else if (txtLocale.trimmedText.uppercased() == "NAILQUEEN"){
                base = "http://103.253.14.203:4012/Main_API/"
                baseDashboard = "http://103.253.14.203:4012/Main_API/"}
            else if (txtLocale.trimmedText.uppercased() == "SINCERESKIN"){
                base = "http://103.253.15.102:9598/Main_API/"
                baseDashboard = "http://103.253.15.102:9598/Main_API/"}
            else if (txtLocale.trimmedText.uppercased() == "SLBEAUTY"){
                base = "http://103.253.15.102:9595/Main_API/"
                baseDashboard = "http://103.253.15.102:9595/Main_API/"}
            else if (txtLocale.trimmedText.uppercased() == "ESTHETIKA"){
                base = "http://103.253.15.102:9399/Main_API/api/"
                baseDashboard = "http://103.253.15.102:9399/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ESTHETICA"){
                base = "http://103.253.15.102:9399/Main_API/api/"
                baseDashboard = "http://103.253.15.102:9399/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "KIREI"){
                base = "http://103.253.15.102:9596/Main_API/api/"
                baseDashboard = "http://103.253.15.102:9596/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "LUXELLE"){
                base = "http://103.253.14.203:4030/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4030/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "FOREVER"){
                base = "http://103.253.14.203:4031/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4031/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "LOYALSPA"){
                base = "http://103.253.14.203:4042/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4042/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "MONARCH"){
                base = "http://103.253.14.203:4043/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4043/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "ZENTH"){
                base = "http://103.253.14.203:4041/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4041/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "DVCBORNEO"){
                base = "http://103.253.14.203:4046/Main_API/api/"
                baseDashboard = "http://103.253.14.203:4046/Main_API/api/"}
            else if (txtLocale.trimmedText.uppercased() == "SCENEFIS"){
                base = "http://103.253.15.75:7049/Main_API/api/"
                baseDashboard = "http://103.253.15.75:7049/Main_API/api/"}
            else {
                base = "http://103.253.14.203/main/api/"
                baseDashboard = "http://103.253.14.203/main/api/"}
            
            UserDefaults.standard.set(base, forKey: "base") //setObject
            UserDefaults.standard.set(txtLocale.trimmedText.uppercased(), forKey: "locale") //setObject
            //
             login()
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
}
