//
//  CreateEmployeeEmailVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/16/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class CreateEmployeeEmailVC: UIViewController {

    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFLdPassword: UITextField!
    @IBOutlet weak var txtFldCPassword: UITextField!
    
    
    var employeeStaffCode:String = ""
    var parameterDict:[String:Any]=[:]
    var staffMember: StaffMember?
    var isComesFromUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldEmail.text = ""
        if isComesFromUpdate {
           txtFldEmail.text = staffMember?.email ?? ""
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnTap(_ sender: Any) {
        if txtFldEmail.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter email"))
        }else if txtFLdPassword.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter passwor"))
        }else if txtFldCPassword.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter confirm password"))
        }else if txtFLdPassword.text != txtFldCPassword.text{
            self.singleButtonAlertWith(message: .custom("Password not matched"))
        }else {
            parameterDict.updateValue(txtFldEmail.text!, forKey: "userLogin")
            parameterDict.updateValue(txtFLdPassword.text!, forKey: "password")
            let url = "\(base)\(Apis.createEmployeeSetting)"
            WebService.shared.postDataFor(api: url, parameters: parameterDict as [String : AnyObject]) { (sucess, response, msg) in
                self.singleButtonAlertWith(message: .custom("Employee Settings is created successfully") , completionOnButton: {
                self.navigationController?.popToRootViewController(animated: true)                })
            }
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

