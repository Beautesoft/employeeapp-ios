//
//  SettingVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/4/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchPushNotificationSetting()
    }
    
    @IBOutlet weak var switchPush: UISwitch!
    
    
    @IBAction func helpbtnTap(_ sender: Any) {
        let vc = TermsConditionVC.instantiateFrom(storyboard: .prelogin)
        vc.page = .help
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func privacyBtnTap(_ sender: Any) {
        let vc = TermsConditionVC.instantiateFrom(storyboard: .prelogin)
        vc.page = .privacyPolicy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func termsConditionBtnTap(_ sender: Any) {
        let vc = TermsConditionVC.instantiateFrom(storyboard: .prelogin)
        vc.page = .terms
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func changePasswordBtnTap(_ sender: Any) {
        let vc = ResetPasswordVC.instantiateFrom(storyboard: .settings)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func whatNewBtnTap(_ sender: Any) {
        let vc = WhatsNewVC.instantiateFrom(storyboard: .settings)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtnTap(_ sender: Any) {
        self.alertWith(message: Messages.logoffMessage, actions: (.cancel, nil), (.ok, {
            AppDelegate.shared.logout()
        }))
       
    }
    @IBAction func actionSwitch(_ sender: UISwitch) {
        updatePushNotificationSetting(status: self.switchPush.isOn ? 1 : 0 )
    }
    
    func fetchPushNotificationSetting() {
        let param = [
            "userID": profile.userID ?? "",
            "siteCode": profile.siteCode ?? "",
            "deviceToken": UserDefaultsManager.deviceToken ?? ""
        ]
        WebService.shared.postDataFor(api: base + Apis.getPushNotification, parameters: param as [String : AnyObject]) { (success, response, message) in
            if success {
                
                if let reuslt = response["result"] as? [[String:Any]], let dict = reuslt.first, let status = dict["status"] as? Bool {
                    self.switchPush.setOn(status, animated: false)
                }
            }
        }
    }
    
    func updatePushNotificationSetting(status: Int) {
        let param = [
            "staffCode": profile.staffCode ?? "",
            "userID": profile.userID ?? "",
            "status": "\(status)",
            "siteCode": profile.siteCode ?? "",
            "phoneNumber" : profile.phoneNumber ?? ""
            
        ]
        WebService.shared.postDataFor(api: base + Apis.updatePushNotificationSetting, parameters: param as [String : AnyObject]) { (success, result, message) in
            if !success {
                let state = self.switchPush.isOn
                self.switchPush.setOn(!state, animated: true)
            }
        }
    }
}
