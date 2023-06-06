//
//  FilterVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/4/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

protocol SendFilterData: class {
    func sendFilterData(siteListingID:String, deptID:String, status:String, seletedDate:String,viewType: ViewType,taskType: String)
}

class FilterVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
     @IBOutlet var txtFldViewType: UITextField!
    
    @IBOutlet weak var textFiledTaskType: UITextField!
    var filterDelegate: SendFilterData?
    @IBOutlet var statusTF: UITextField!
    @IBOutlet var nameOfDeptTF: UITextField!
    @IBOutlet var siteNameTF: UITextField!
    @IBOutlet var selectDateTF: UITextField!
    var activeField: UITextField?
    var picker =  UIPickerView()
    var pickerViewType =  UIPickerView()
    var datePicker =  UIDatePicker()
    var statusOptionArr:[TaskStatus] = [.accepted,.confirmed,.completed,.cancelled,.pending,.open, .deleted]
    var arrDepartmentList = [DepartmentList]()
    var arrOptionList = [SiteListingOption]()
    var viewType:[ViewType] = [.assignedToMe, .createdByMe]
    var pickerVwStatusOptionType = UIPickerView()
    var pickerVwDepartmentType = UIPickerView()
    var pickerVwSiteListing = UIPickerView()
    var pickerVwTaskType = UIPickerView()
    var siteItemCode:String = ""
    var depId:String = ""
    var selectedDate: String = ""
    var selectedviewType: ViewType = .createdByMe
    var taskTypeArr: [TaskTypesFilter] = [.all,.appointment, .bankIn, .external, .outletRequest, .walkIn]
    var selectedTaskType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        siteNameTF.delegate = self
        nameOfDeptTF.delegate = self
        statusTF.delegate = self
        textFiledTaskType.delegate = self

        txtFldViewType.delegate = self
        
        setDatePicker()
        setPicker()
        statusTF.leftViewMode = UITextField.ViewMode.always
        statusTF.rightView = UIImageView(image: UIImage(named: "calendar"))

        nameOfDeptTF.leftViewMode = UITextField.ViewMode.always
        nameOfDeptTF.rightView = UIImageView(image: UIImage(named: "calendar"))

        siteNameTF.leftViewMode = UITextField.ViewMode.always
        siteNameTF.rightView = UIImageView(image: UIImage(named: "calendar"))

        selectDateTF.leftViewMode = UITextField.ViewMode.always
        selectDateTF.rightView = UIImageView(image: UIImage(named: "calendar"))

        getDepartmentList()
        // Do any additional setup after loading the view.
    }

    @IBAction func applyBtnTap(_ sender: Any) {
        filterDelegate?.sendFilterData(siteListingID: siteItemCode, deptID: depId, status: statusTF.text!, seletedDate: selectedDate,viewType: selectedviewType, taskType: selectedTaskType ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    func getDepartmentList(){
        let url = "\(base)\(Apis.getDepartmentList)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response , msg) in
            if let result = response["result"] as? [[String: Any]] {
                self.arrDepartmentList.removeAll()
                result.forEach({ (dict) in
                    self.arrDepartmentList.append(DepartmentList(fromDictionary: dict))
                })
            }
            self.getSiteListing()
        }
    }
    func getSiteListing(){
        let actionURL = "\(base)\(Apis.siteListing)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response , msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrOptionList.append(SiteListingOption(fromDictionary: dict))
                })
            }
        }
    }
    // SET PICKER
    func setDatePicker(){

        datePicker = UIDatePicker(frame: CGRect(x:0, y:200, width:view.frame.width,height: 200))
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }

        }
        selectDateTF.inputView = datePicker

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
       
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker(sender:)))
        doneButton.tag = 1
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        selectDateTF.inputAccessoryView = toolBar
    }
    func setPicker(){
        picker = UIPickerView(frame: CGRect(x:0, y:200, width:view.frame.width,height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        statusTF.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker(sender:)))
        doneButton.tag = 2
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancel) )
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        siteNameTF.inputAccessoryView = toolBar
        nameOfDeptTF.inputAccessoryView = toolBar
        statusTF.inputAccessoryView = toolBar
    }

    @objc func donePicker(sender: UIBarButtonItem){
        if sender.tag == 1 {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            selectedDate = formatter.string(from: datePicker.date)
            formatter.dateFormat =  "dd MMM yyyy"
            selectDateTF.text = formatter.string(from: datePicker.date)
        } 
        self.view.endEditing(true)
    }
    @objc func cancel() {
        self.view.endEditing(true)
    }
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerVwSiteListing {
           return arrOptionList.count
        }else if pickerView == pickerVwDepartmentType {
            return arrDepartmentList.count
        }else if pickerView == pickerVwStatusOptionType {
            return  self.statusOptionArr.count
        }else if pickerView == pickerViewType {
            return  self.viewType.count
        }else if pickerView == pickerVwTaskType {
            return  self.taskTypeArr.count
        }
        return arrOptionList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerVwSiteListing {
            let selectedcategory = arrOptionList[row].itemDesc ?? ""
            return selectedcategory
        }else if pickerView == pickerVwDepartmentType {
            let selectedcategory = arrDepartmentList[row].departmentName ?? ""
            return selectedcategory
        }else if pickerView == pickerVwStatusOptionType {
            let selectedcategory = statusOptionArr[row].rawValue
            return selectedcategory
        }else if pickerView == pickerViewType {
            let viewType = self.viewType[row].rawValue
            return viewType
        }else if pickerView == pickerVwTaskType {
            return taskTypeArr[row].value
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if pickerView == pickerVwSiteListing {
            let siteListing = arrOptionList[row]
            let categoryList =  siteListing.itemDesc ?? ""
            siteNameTF.text = categoryList
            siteItemCode = siteListing.itemCode ?? ""
        }else if pickerView == pickerVwDepartmentType {
            let departmentList = arrDepartmentList[row]
            nameOfDeptTF.text = departmentList.departmentName ?? ""
            depId = departmentList.departmentCode ?? ""
        }else if pickerView == pickerVwStatusOptionType {
            let categoryList =  self.statusOptionArr[row].rawValue
            statusTF.text = categoryList
        }else if pickerView == pickerViewType {
            let viewType =  self.viewType[row].rawValue
            txtFldViewType.text = viewType
            if viewType == "Created By Me" {
               selectedviewType = .createdByMe
            }else {
               selectedviewType = .assignedToMe
            }
        }else if pickerView == pickerVwTaskType {
            selectedTaskType = taskTypeArr[row].rawValue
            textFiledTaskType.text = taskTypeArr[row].value
        }
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension FilterVC: UITextFieldDelegate {
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerVwSiteListing.delegate = self
        pickerVwSiteListing.dataSource  = self
        pickerVwSiteListing.reloadAllComponents()
        
        pickerVwDepartmentType.delegate = self
        pickerVwDepartmentType.dataSource  = self
        pickerVwDepartmentType.reloadAllComponents()
        
        pickerVwStatusOptionType.delegate = self
        pickerVwStatusOptionType.dataSource  = self
        pickerVwStatusOptionType.reloadAllComponents()
        
        pickerViewType.delegate = self
        pickerViewType.dataSource  = self
        pickerViewType.reloadAllComponents()

        pickerVwTaskType.delegate = self
        pickerVwTaskType.dataSource  = self
        pickerVwTaskType.reloadAllComponents()

         if textField == siteNameTF {
            siteNameTF.inputView = pickerVwSiteListing
            if siteNameTF.text == "" {
                let row = pickerVwSiteListing.selectedRow(inComponent: 0)
                let siteListing = arrOptionList[row]
                siteNameTF.text = siteListing.itemDesc ?? ""
                siteItemCode = siteListing.itemCode ?? ""
            }
        }else if textField == nameOfDeptTF {
            nameOfDeptTF.inputView = pickerVwDepartmentType
            if nameOfDeptTF.text == "" {
                let row = pickerVwDepartmentType.selectedRow(inComponent: 0)
                let departmentList = arrDepartmentList[row]
                nameOfDeptTF.text = departmentList.departmentName ?? ""
                depId = departmentList.departmentCode ?? ""
            }
         }else if textField == statusTF {
            statusTF.inputView = pickerVwStatusOptionType
            if statusTF.text == "" {
                let row = pickerVwStatusOptionType.selectedRow(inComponent: 0)
                let categoryList =  self.statusOptionArr[row].rawValue
                statusTF.text = categoryList
            }
         }else if textField == txtFldViewType {
            txtFldViewType.inputView = pickerViewType
            if txtFldViewType.text == "" {
                let row = pickerViewType.selectedRow(inComponent: 0)
                let viewType =  self.viewType[row].rawValue
                txtFldViewType.text = viewType
                if viewType == "Created By Me" {
                    selectedviewType = .createdByMe
                }else {
                    selectedviewType = .assignedToMe
                }
            }
         }else if textField == textFiledTaskType {
            textFiledTaskType.inputView = pickerVwTaskType
            if textFiledTaskType.text == "" {
                let row = pickerVwTaskType.selectedRow(inComponent: 0)
                let taskType =  self.taskTypeArr[row].value
                textFiledTaskType.text = self.taskTypeArr[row].value
                selectedTaskType = self.taskTypeArr[row].rawValue
            }
        }
   }
}
