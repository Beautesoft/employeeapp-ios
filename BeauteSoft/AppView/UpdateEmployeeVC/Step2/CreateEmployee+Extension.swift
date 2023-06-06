//
//  CreateEmployee+Extension.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 29/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
import UIKit
//MARK: UItableVwdelegate And UITableDataSources
extension CreateEmployeeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllowedOption.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVwList.dequeueReusableCell(withIdentifier: "CreateEmployeeTVC", for: indexPath) as! CreateEmployeeTVC
        let alloweddvalues = arrAllowedOption[indexPath.row]
        cell.lblOptionName.text = alloweddvalues.0.rawValue
        cell.btnSelectOption.isSelected = alloweddvalues.1
        cell.btnSelectOption.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
//Picker View
//PICKER VIEW DELEGATES AND DATASPURCES
extension CreateEmployeeVC: UIPickerViewDataSource,UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerVwDesignationList {
            return arrDesignationList.count
        }else if pickerView == pickerVwEmployeeSecurity {
            return  self.arrEmployeeSecurity.count
        }else if pickerView == pickerVwSkillSet {
            return  arrSkillSet.count
        }else if pickerView == pickerVwDays {
            return arrDays.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerVwDesignationList {
            return arrDesignationList[row].itemDesc
        }else if pickerView == pickerVwEmployeeSecurity {
            return arrEmployeeSecurity[row].itemDesc
        }else if pickerView == pickerVwSkillSet {
            return arrSkillSet[row].itemDesc
        }else if pickerView == pickerVwDays {
            return arrDays[row].rawValue
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if pickerView == pickerVwDesignationList {
            let model = arrDesignationList[row]
            txtFldDesignation.text = model.itemDesc
            designationCode = model.itemCode
        }else if pickerView == pickerVwEmployeeSecurity {
            let model = arrEmployeeSecurity[row]
            txtFldSecurityLevel.text = model.itemDesc
            empSecurityCode = model.itemCode
        }else if pickerView == pickerVwSkillSet {
            let model = arrSkillSet[row]
            txtFldSkillSet.text = model.itemDesc
            empSkillSetCode = model.itemCode
        }else if pickerView == pickerVwDays {
            txtFldWeekDay.text = arrDays[row].rawValue
        }
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
extension CreateEmployeeVC: UITextFieldDelegate {
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerVwDesignationList.delegate = self
        pickerVwDesignationList.dataSource  = self
        pickerVwDesignationList.reloadAllComponents()
        
        pickerVwSkillSet.delegate = self
        pickerVwSkillSet.dataSource  = self
        pickerVwSkillSet.reloadAllComponents()
        
        pickerVwEmployeeSecurity.delegate = self
        pickerVwEmployeeSecurity.dataSource  = self
        pickerVwEmployeeSecurity.reloadAllComponents()
        
        pickerVwDays.delegate = self
        pickerVwDays.dataSource  = self
        pickerVwDays.reloadAllComponents()
        
        if textField == txtFldJointDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            txtFldJointDate.text = formatter.string(from: datePicker.date)
            datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)
                ), for: .valueChanged)
        }else if textField == txtFldWeekDay {
            txtFldWeekDay.inputView = pickerVwDays
            if txtFldWeekDay.text == "" {
                let row = pickerVwDays.selectedRow(inComponent: 0)
                txtFldWeekDay.text = arrDays[row].rawValue
                //selectedGenderCode = gender.itemCode
            }
        }else if textField == txtFldDesignation {
            txtFldDesignation.inputView = pickerVwDesignationList
            if txtFldDesignation.text == "" {
                let row = pickerVwDesignationList.selectedRow(inComponent: 0)
                let model = arrDesignationList[row]
                txtFldDesignation.text = model.itemDesc
                designationCode = model.itemCode
            }
        }else if textField == txtFldSkillSet {
            txtFldSkillSet.inputView = pickerVwSkillSet
            if txtFldSkillSet.text == "" {
                let row = pickerVwSkillSet.selectedRow(inComponent: 0)
                let model = arrSkillSet[row]
                txtFldSkillSet.text = model.itemDesc
                empSkillSetCode = model.itemCode
            }
        }else if textField == txtFldSecurityLevel {
            txtFldSecurityLevel.inputView = pickerVwEmployeeSecurity
            if txtFldSecurityLevel.text == "" {
                let row = pickerVwEmployeeSecurity.selectedRow(inComponent: 0)
                let model = arrEmployeeSecurity[row]
                txtFldSecurityLevel.text = model.itemDesc
                securityLevel = model.itemCode
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
