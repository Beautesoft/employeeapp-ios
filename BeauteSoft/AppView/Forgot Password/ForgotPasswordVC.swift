//
//  ForgotPasswordVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 2/4/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTF: UITextField!
    
    let forgotPasswordBL = ForgotPasswordBL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func submitBtnTap(_ sender: Any) {
        self.view.endEditing(true)
        if usernameTF.isBlank {
            self.singleButtonAlertWith(message: Messages.emailPlease)
        }else{
            forgotPasswordApi()
        }
        
    }
    func forgotPasswordApi(){
        let parameter = ["userID":usernameTF.trimmedText,"email": usernameTF.trimmedText] as [String : AnyObject]
        forgotPasswordBL.forgotPassword(params: parameter) {
            self.singleButtonAlertWith(message: Messages.passwordSent, completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }


    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
