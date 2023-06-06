//
//  UpdateEmployeeStepFourVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/16/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class submitAppointmentcell:UITableViewCell{
    
}

class SalaryCell:UITableViewCell{
    
    @IBOutlet var employerEPF: UITextField!
    @IBOutlet var employeeEPF: UITextField!
    @IBOutlet var epfNumTF: UITextField!
    @IBOutlet var amtTF: UITextField!
    @IBOutlet var socsoTF: UITextField!
    @IBOutlet var salaryTF: UITextField!
}
class TargetCell:UITableViewCell{
    
    @IBOutlet var periodTF: UITextField!
    @IBOutlet var targetValTF: UITextField!
    @IBOutlet var targetTypeTF: UITextField!
}
class tableContentCell:UITableViewCell{
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet var heightContraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
}
class contentContainerCell:UITableViewCell{
    
    @IBOutlet var selectTypeBtn: UIButton!
    @IBOutlet var containerLbl: UILabel!
}
class UpdateEmployeeStepFourVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var superTblView: UITableView!
   
    //MARK: - variables
    var staffCodeStrval:String = ""
    var arrAppoinmentList = [GetAppointmentGroupList]()
    var arrGetTargetType = [TargetType]()
    var arrTargetPeriod = [TargetPeriod]()
    var pickerVwTargetType = UIPickerView()
    var pickerVwPeriodType = UIPickerView()
    var parameterDict:[String:Any] = [:]
    var targetTypeCode: String?
    var periodTypeCode: String?
    var staffMember: StaffMember?
    var isComesFromUpdate = false
    
    @IBOutlet weak var txtFldEmpPer: UITextField!
    @IBOutlet weak var txtFldSoscoAmt: UITextField!
    @IBOutlet weak var txtFldSoscoNo: UITextField!
    @IBOutlet weak var txtFldSalary: UITextField!
    @IBOutlet weak var txtFldEpfNo: UITextField!
    @IBOutlet weak var txtFldEmpEpfPer: UITextField!
    @IBOutlet weak var txtFldTargetType: UITextField!
    @IBOutlet weak var txtFldTargetValue: UITextField!
    @IBOutlet weak var txtFldTargetPeriod: UITextField!
    @IBOutlet weak var txtFldTheripis: UITextField!
    @IBOutlet weak var btnSelectTheripist: UIButton!
    @IBOutlet weak var tableVwList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // headerTitleLbl.text = "Create New Employee"
        if isComesFromUpdate {
           showData()
        }
        getAppointmentList()
    }
    
    private func showData() {
       // Same with TargetType. What is saved and get. It should be AMOUNT or QTY instead of 001 or 002
        txtFldEmpPer.text = "\(staffMember?.employerEpf  ?? 0.0)"
        txtFldSoscoAmt.text = "\(staffMember?.empSocsoAmt ?? 0.0)"
        txtFldSoscoNo.text = staffMember?.empSocsoNo ?? ""
        txtFldSalary.text = "\(staffMember?.empSalary ?? 0.0)"
        txtFldEpfNo.text = staffMember?.empEpfNo ?? ""
        txtFldEmpEpfPer.text = "\(staffMember?.employeeEpf ?? 0.0)"
        txtFldTargetValue.text = staffMember?.target
        txtFldTargetType.text = staffMember?.targetType == "001" ? "AMOUNT" : "QTY"
       
        if staffMember?.targetPeriod == "001" {
          txtFldTargetPeriod.text = "WEEK"
        }else if staffMember?.targetPeriod == "002" {
          txtFldTargetPeriod.text = "MONTH"
        }else if staffMember?.targetPeriod == "YEAR" {
          txtFldTargetPeriod.text = "Year"
        }else {
          txtFldTargetPeriod.text = "WEEK"
        }
    }
    
    //MARK: - GetAppoinmentList
    func getAppointmentList(){
        let url = "\(base)\(Apis.getAppointmentGroupList)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (bool, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrAppoinmentList.append(GetAppointmentGroupList(fromDictionary: dict))
                })
                self.tableVwList.reloadData()
                self.getTargetType()
            }
        }
    }
    //MARK: - GetTargetType
    func getTargetType(){
        let url = "\(base)\(Apis.targetType)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (bool, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrGetTargetType.append(TargetType(fromDictionary: dict))
                })
                 self.getTargetPeriod()
            }
        }
    }
    //MARK: - GetTargetPeriod
    func getTargetPeriod(){
        let url = "\(base)\(Apis.targetPeriod)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (bool, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrTargetPeriod.append(TargetPeriod(fromDictionary: dict))
                })
            }
        }
    }

    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSubmit(_ sender: Any) {
        if txtFldSalary.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter Salary"))
        }else if txtFldSoscoNo.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter SOSCo number"))
        }else if txtFldSoscoAmt.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter SOSCo AMT"))
        }else if txtFldEpfNo.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter EPF num"))
        }else if txtFldEmpPer.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter employee epf"))
        }else if txtFldEmpEpfPer.isBlank {
            self.singleButtonAlertWith(message: .custom("Please  employer epf"))
        }else if txtFldTargetType.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter Target type"))
        }else if txtFldTargetValue.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter Target value"))
        }else if txtFldTargetPeriod.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter period"))
        }else {
            webServiceForCreateEmpStep4 ()
        }
    }
    @IBAction func actionSelectTheripist(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        arrAppoinmentList[sender.tag].isSelected = !arrAppoinmentList[sender.tag].isSelected
        self.tableVwList.reloadData()
    }
    var containSelectedListArr:[[String:Any]] = []
  
    @IBAction func appointmentBtnTap(_ sender: UIButton) {
        let cell = superTblView.cellForRow(at: IndexPath(row: 0, section: 2)) as! tableContentCell
        if sender.isSelected {
            sender.isSelected = false
            cell.heightContraint.constant = 180
            cell.expandBtn.setImage(UIImage(named: "up"), for: .normal)
        }else{
            sender.isSelected = true
            cell.heightContraint.constant = 0
            cell.expandBtn.setImage(UIImage(named: "down"), for: .normal)
        }
    }
    var paramDict:[String:Any] = [:]
    private func webServiceForCreateEmpStep4 (){
        let selectedItem: [GetAppointmentGroupList] = (arrAppoinmentList.filter{$0.isSelected})
        let selectedAppGroup = Utility.shared.getSiteListingParameter(appoinmentListing: selectedItem)
        
//                let parameter = [
//                         "empSalary": txtFldSalary.text ?? "",
//                         "siteCode":profile.siteCode ?? "",
//                         "Appointment": selectedAppGroup,
//                         "empSocsoNo": txtFldSoscoNo.text ?? "",
//                         "empSocsoAmt": txtFldSoscoAmt.text ?? "",
//                         "empEpfNo": txtFldEpfNo.text ?? "",
//                         "employeeEpf": txtFldEmpPer.text ?? "",
//                         "employerEpf": txtFldEmpEpfPer.text ?? "",
//                         "targetType":targetTypeCode ?? "",
//                         "target": txtFldTargetValue.text ?? "",
//                         "targetPeriod": periodTypeCode,
//                         "staffCode":staffCodeStrval ]
        paramDict.updateValue(txtFldSalary.text ?? "", forKey: "empSalary")
        paramDict.updateValue(profile.siteCode ?? "", forKey: "siteCode")
        paramDict.updateValue(selectedAppGroup, forKey: "Appointment")
        paramDict.updateValue(txtFldSoscoNo.text ?? "", forKey: "empSocsoNo")
        paramDict.updateValue(txtFldSoscoAmt.text ?? "", forKey: "empSocsoAmt")
        paramDict.updateValue(txtFldEpfNo.text ?? "", forKey: "empEpfNo")
        paramDict.updateValue(txtFldEmpEpfPer.text ?? "", forKey: "employeeEpf")
        paramDict.updateValue(txtFldEmpEpfPer.text ?? "", forKey: "employerEpf")
        paramDict.updateValue(targetTypeCode ?? "", forKey: "targetType")
        paramDict.updateValue(txtFldTargetValue.text ?? "", forKey: "target")
        paramDict.updateValue(periodTypeCode ?? "", forKey: "targetPeriod")
        paramDict.updateValue(staffCodeStrval, forKey: "staffCode")
     
        var actionUrl: String?
        if isComesFromUpdate {
            actionUrl = "\(base)\(Apis.UpdateSalaryTargetAppt)"
        }else {
            actionUrl = "\(base)\(Apis.createSalaryTargerApp)"
        }
        WebService.shared.postDataFor(api: actionUrl ?? "", parameters: paramDict as [String : AnyObject]) { (sucess, response, msg) in
            let vc = CreateEmployeeEmailVC.instantiateFrom(storyboard: .employee)
            vc.parameterDict = self.parameterDict
            vc.staffMember = self.staffMember
            vc.isComesFromUpdate = self.isComesFromUpdate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UpdateEmployeeStepFourVC: UIPickerViewDataSource,UIPickerViewDelegate{
    //Picker View
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerVwTargetType {
            return arrGetTargetType.count
        }else if pickerView == pickerVwPeriodType {
            return  self.arrTargetPeriod.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerVwTargetType {
            return arrGetTargetType[row].itemDesc
        }else if pickerView == pickerVwPeriodType {
            return arrTargetPeriod[row].itemDesc
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if pickerView == pickerVwTargetType {
            let model = arrGetTargetType[row]
            txtFldTargetType.text = model.itemDesc
            targetTypeCode = model.itemCode
        }else if pickerView == pickerVwPeriodType {
            let model = arrTargetPeriod[row]
            txtFldTargetPeriod.text = model.itemDesc
            periodTypeCode = model.itemCode
        }
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
extension UpdateEmployeeStepFourVC: UITextFieldDelegate {
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerVwTargetType.delegate = self
        pickerVwTargetType.dataSource  = self
        pickerVwTargetType.reloadAllComponents()
        
        pickerVwPeriodType.delegate = self
        pickerVwPeriodType.dataSource  = self
        pickerVwPeriodType.reloadAllComponents()
        
        
       if textField == txtFldTargetType {
            txtFldTargetType.inputView = pickerVwTargetType
            if txtFldTargetType.text == "" {
                let row = pickerVwTargetType.selectedRow(inComponent: 0)
                txtFldTargetType.text = arrGetTargetType[row].itemDesc
                targetTypeCode = arrGetTargetType[row].itemCode
            }
        }else if textField == txtFldTargetPeriod {
            txtFldTargetPeriod.inputView = pickerVwPeriodType
            if txtFldTargetPeriod.text == "" {
                let row = pickerVwPeriodType.selectedRow(inComponent: 0)
                let model = arrTargetPeriod[row]
                txtFldTargetPeriod.text = model.itemDesc
                periodTypeCode = model.itemCode
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension UpdateEmployeeStepFourVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAppoinmentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.AppoimentInformationTVC.rawValue, for: indexPath) as! AppoimentInformationTVC
        let model = arrAppoinmentList[indexPath.row]
        cell.lblOptionName.text = model.groupName
       // cell.btnSelectedoption.isSelected = staffMember.t
        cell.btnSelectedoption.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
