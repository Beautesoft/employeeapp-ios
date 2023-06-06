//
//  EmployeeLeaveListVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class EmployeeLeaveListVC: UIViewController {

    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var toDateOutlet: UIButton!
    @IBOutlet var fromDateBtn: UIButton!
    @IBOutlet var datePickerContainerView: UIView!
    var fromDate:String = ""
    var toDate:String = ""
    var checkInt:Int = -1
    var getEmpLeaveDict:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
    }
    
   
    @IBAction func datePickerValChanged(_ sender: Any) {
        setDateToFields()
    }
    
    func setDateToFields() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        if checkInt  == 1{
            let strDate = dateFormatter.string(from: datePicker.date)
            fromDate  = strDate
            fromDateBtn.setTitle(strDate, for: .normal)
            // amontDateFrom1 = strDate
        }else{
            let strDate = dateFormatter.string(from: datePicker.date)
            toDate = strDate
            toDateOutlet.setTitle(strDate, for: .normal)
        }
    }
    @IBAction func toDateBtnTap(_ sender: Any) {
        checkInt = 0
        if datePickerContainerView.isHidden{
            datePickerContainerView.isHidden = false
        }else{
            datePickerContainerView.isHidden = true
        }
    }
    @IBAction func fromDateBTnTap(_ sender: Any) {
        checkInt = 1
        if datePickerContainerView.isHidden{
            datePickerContainerView.isHidden = false
        }else{
            datePickerContainerView.isHidden = true
        }
    }
   
    
    @IBAction func submitBtnTap(_ sender: Any) {
        if fromDate == ""{
            singleButtonAlertWith(message: .chooseFromDate)
        } else if toDate == ""{
            singleButtonAlertWith(message: .chooseToDate)
        } else{
            let sideCode = profile.siteCode ?? ""
            let param = ["siteCode":sideCode,"fromDate":fromDate,"toDate":toDate]
            WebService.shared.postDataFor(api: base + Apis.getEmpLeave, parameters: param as [String : AnyObject] ){ (success, response, result) in
                if let result = response["result"] as? [[String:Any]]{
                    self.getEmpLeaveDict = result
                    self.goToNextVC()
                }
            }
        }
        
    }
    
    func goToNextVC(){
        let vc = GetEmployeeLeaveListVC.instantiateFrom(storyboard: .reports)
        vc.listArrDict =  self.getEmpLeaveDict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func donebtnTap(_ sender: Any) {
        setDateToFields()
        datePickerContainerView.isHidden = true
    }
    

}
