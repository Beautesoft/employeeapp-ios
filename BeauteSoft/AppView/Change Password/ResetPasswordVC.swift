//
//  ResetPasswordVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/7/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var previousPassTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    @IBAction func updateBtnTap(_ sender: Any) {
        let userId = profile.userID ?? ""
        let siteCode =  profile.siteCode ?? ""
        let email =  profile.email ?? ""
        let parameter = ["oldPassword": previousPassTF.text!,"password":newPassTF.text!,"confirmed":confirmPassTF.text!,"userID":userId,"siteCode":siteCode,"email":email] as [String : AnyObject]
        print(parameter)
        
        WebService.shared.postDataFor(api: base + Apis.resetPassword, parameters: parameter) { (success, result, message) in
            AppDelegate.shared.logout()
        }
        
    }
    
}
