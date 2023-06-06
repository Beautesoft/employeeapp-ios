//
//  ToppersSaleVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class ToppersSaleVC: UIViewController {
    
    var checkInt:Int = -1
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerSuperView: UIView!
    @IBOutlet var fromDateBtn: UIButton!
    @IBOutlet var toDateBtn: UIButton!
    var fromDate:String = ""
    var toDate:String = ""
    
    var isSale:Bool = false
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
            fromDate = strDate
            fromDateBtn.setTitle(strDate, for: .normal)
            // amontDateFrom1 = strDate
        }else{
            let strDate = dateFormatter.string(from: datePicker.date)
            toDate = strDate
            toDateBtn.setTitle(strDate, for: .normal)
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkValidation(){
        if fromDate == ""{
            self.singleButtonAlertWith(message: .chooseFromDate)
        }else if toDate == ""{
             self.singleButtonAlertWith(message: .chooseToDate)
        }else{
            let vc = ListTopperVC.instantiateFrom(storyboard: .reports)
            vc.fromDate = fromDate
            vc.toDate = toDate
            vc.isSale = isSale
            vc.isComingFrom = false
            datePickerSuperView.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @IBAction func listPoorersBtnTap(_ sender: Any) {
          isSale = true
        checkValidation()
    }
    @IBAction func listTopperBtnTap(_ sender: Any) {
        isSale = false
        checkValidation()
    }
    
    @IBAction func toDateBtnTap(_ sender: Any) {
        checkInt = 0
        if datePickerSuperView.isHidden{
            datePickerSuperView.isHidden = false
        }else{
            datePickerSuperView.isHidden = true
        }
    }
    
    @IBAction func fromDateBtnTap(_ sender: Any) {
        checkInt = 1
        if datePickerSuperView.isHidden{
            datePickerSuperView.isHidden = false
        }else{
            datePickerSuperView.isHidden = true
        }
    }
    
    @IBAction func doneBtnTap(_ sender: Any) {
        datePickerSuperView.isHidden = true
    }
}
