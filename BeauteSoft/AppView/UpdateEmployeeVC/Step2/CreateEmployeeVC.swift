//
//  CreateEmployeeVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 22/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class CreateEmployeeVC: UIViewController {
    
    
    @IBOutlet weak var txtFldSkillSet: UITextField!
    @IBOutlet weak var txtFldDesignation: UITextField!
    @IBOutlet weak var txtFldWeekDay: UITextField!
    @IBOutlet weak var txtFldJointDate: UITextField!
    @IBOutlet weak var txtFldMaxDiscount: UITextField!
    @IBOutlet weak var txtFldEmpBarCode: UITextField!
    @IBOutlet weak var txtFldSecurityLevel: UITextField!
    @IBOutlet weak var tableVwList: UITableView!
    @IBOutlet weak var tableVw: UITableView!
    
    var arrDesignationList = [DesignationList]()
    var arrSkillSet = [SkillSet]()
    var arrEmployeeSecurity = [EmployeeSecurity]()
    
    var pickerVwDesignationList = UIPickerView()
    var pickerVwSkillSet = UIPickerView()
    var pickerVwEmployeeSecurity = UIPickerView()
    var pickerVwDays = UIPickerView()
    var datePicker = UIDatePicker()
    var paramDict:[String:Any] = [:]
    var staffMember: StaffMember?
    
    enum AllowedOption : String {
        case sales = "Show in Sales"
        case treatment = "Show in Treatment"
        case appointment = "Show in Appointment"
        case commission = "Allow Commission"
        case purchase = "Allow Staff Purchase"
    }
    enum Days : String {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
    var arrDays: [Days] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    var arrAllowedOption: [(AllowedOption,Bool)] = [(.sales,false), (.treatment,false), (.appointment,false), (.commission,false), (.purchase,false)]
    var designationCode: String?
    var securityLevel: String?
    var empSecurityCode: String?
    var empSkillSetCode: String?
    var employeeImage: UIImageView?
    var staffName: String?
    var isComesFromEdit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldJointDate.inputView = datePicker
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
        getDesignationApi()
        if isComesFromEdit {
            DispatchQueue.main.async {
                self.getStaffMemberDetail()
            }
        }
    }
    //MARK:: button action
    @IBAction func actionSelectOption(_ sender: UIButton) {
        var alloweddvalues = arrAllowedOption[sender.tag]
        alloweddvalues.1 = !alloweddvalues.1
        arrAllowedOption[sender.tag] = alloweddvalues
        tableVwList.reloadData()
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        createEmployee ()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDone(_ sender: UIButton) {
        let arr = arrAllowedOption.filter{$0.1}
        print(arr)
    }
    
    func getDesignationApi(){
        let sideCode = profile.siteCode ?? ""
        let actionURL = "\(base)\(Apis.employeeDesignation)\(sideCode)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrDesignationList.append(DesignationList(fromDictionary: dict))
                })
                self.getSkillSetApi()
            }
        }
    }
    
    func getSkillSetApi(){
        let sideCode = profile.siteCode ?? ""
        let actionURL = "\(base)\(Apis.skillSets)\(sideCode)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrSkillSet.append(SkillSet(fromDictionary: dict))
                })
                self.getSecurityLevelApi()
            }
        }
    }
    func getSecurityLevelApi(){
        let sideCode = profile.siteCode ?? ""
        let actionURL = "\(base)\(Apis.employeeSecurity)\(sideCode)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.arrEmployeeSecurity.append(EmployeeSecurity(fromDictionary: dict))
                })
            }
        }
    }
    
    var staffCode: String?
    var siteCode: String?
    //web service for create employee
    private func createEmployee () {
        if txtFldEmpBarCode.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter employee bar code"))
        }else if txtFldMaxDiscount.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter maximum discount"))
        }else if txtFldJointDate.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter joining date"))
        }else if txtFldWeekDay.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter off day"))
        }else if txtFldDesignation.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select designation"))
        }else if txtFldSkillSet.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select skill set"))
        }else if txtFldSecurityLevel.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select security level"))
        }else {
            webServiceForCreateEmployee()
        }
    }

    private func webServiceForCreateEmployee() {
        paramDict.updateValue(txtFldEmpBarCode.text ?? "", forKey: "empBarcode")
        paramDict.updateValue(txtFldMaxDiscount.text ?? "", forKey: "maxDiscount")
        paramDict.updateValue(txtFldJointDate.text ?? "", forKey: "joiningDate")
        paramDict.updateValue(txtFldWeekDay.text ?? "", forKey: "offDay")
        paramDict.updateValue(designationCode ?? "", forKey: "empPosition")
        paramDict.updateValue(profile.siteCode ?? "", forKey: "siteCode")
        paramDict.updateValue(empSecurityCode ?? "", forKey: "empSecurity")
        paramDict.updateValue(empSkillSetCode ?? "", forKey: "skillset")
        //paramDict.updateValue(profile.staffCode ?? "", forKey: "staffCode")
        paramDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .sales), forKey: "showInSales")
        paramDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .appointment), forKey: "showInAppt")
        paramDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .treatment), forKey: "showInTrmt")
        paramDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .commission), forKey: "allowComm")
        paramDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .purchase), forKey: "allowStaffPurc")
        paramDict.updateValue("1", forKey: "attribute")
       
        let actionUrl: String?
        if isComesFromEdit {
            paramDict.updateValue(staffMember?.staffCode ?? "", forKey: "staffCode")
            actionUrl = "\(base)\(Apis.updateEmployee)"
        }else {
            actionUrl = "\(base)\(Apis.createEmployee)"
        }
        WebService.shared.postDataFor(api: actionUrl ?? "", parameters: paramDict as [String : AnyObject]) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                if let siteCode = response["siteCode"] as? String {
                    self.siteCode = siteCode
                }
                if let dict = result.first {
                    if let staffId = dict["staffCode"] as? String {
                        self.staffCode = staffId
                    }
                    if let staffId = dict["siteCode"] as? String {
                        self.siteCode = staffId
                    }
                    self.updateProfilepicture()
                }
            }
        }
    }
    private func getStaffMemberDetail() {
        //var siteListing = [[String: Any]]()
        var parameterDict :[String:Any] = [:]
       // siteListing = [["siteCode": profile.siteListing[0].siteCode ?? ""]]
        let selectedSiteListing =  Utility.shared.getSiteListingParameter(siteListing: profile.siteListing)
        parameterDict.updateValue(selectedSiteListing, forKey: "SiteListing")
        parameterDict.updateValue(staffMember?.firstName ?? "" , forKey: "staffName")
        parameterDict.updateValue(profile.siteCode ?? "", forKey: "siteCode")
        parameterDict.updateValue(staffMember?.staffCode ?? "", forKey: "staffCode")
        parameterDict.updateValue(profile.userID ?? "", forKey: "userID")
        
        WebService.shared.postDataFor(api: base + Apis.getStaffMember, parameters: parameterDict as [String : AnyObject]) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                if let dict = result.first {
                    self.staffMember = nil
                    self.staffMember = StaffMember(fromDictionary: dict)
                    self.displayValue(dict: dict as NSDictionary)
                }
            }
        }
    }
    
    private func displayValue(dict: NSDictionary) {
        if let showInsalesValue = dict["showInSales"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .sales){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = showInsalesValue
            arrAllowedOption[index] = allowedOption
        }
        if let showInTrmt = dict["showInTrmt"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .treatment){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = showInTrmt
            arrAllowedOption[index] = allowedOption
        }
        if let showInAppt = dict["showInAppt"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .appointment){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = showInAppt
            arrAllowedOption[index] = allowedOption
        }
        if let allowCommition = dict["allowComm"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .commission){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowCommition
            arrAllowedOption[index] = allowedOption
        }
        if let allowStaffPurchase = dict["allowStaffPurc"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .purchase){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowStaffPurchase
            arrAllowedOption[index] = allowedOption
        }
        txtFldSkillSet.text = staffMember?.skillset
        txtFldDesignation.text = staffMember?.empPosition ?? ""
        txtFldWeekDay.text = staffMember?.offDay ?? ""
        txtFldJointDate.text = staffMember?.joiningDate ?? ""
        txtFldMaxDiscount.text = staffMember?.maxDiscount ?? ""
        txtFldEmpBarCode.text = staffMember?.empBarcode ?? ""
        txtFldSecurityLevel.text = staffMember?.empSecurity ?? ""
        tableVwList.reloadData()
    }
    
    private func updateProfilepicture() {
        let imgdict = ["file": employeeImage?.image?.jpegData(compressionQuality: 0.6) ?? Data()]
        let josnDict = Utility.shared.json(from: ["siteCode": siteCode , "staffCode": staffCode ?? ""])
        let params = ["jsonKey":josnDict ?? ""] as [String : AnyObject]
        WebService.shared.uploadMediaToServer(api: base + Apis.updateProfilePicture, imgMedia: imgdict , parameters: params) { (sucess, result, msg) in
            self.singleButtonAlertWith(message: .custom(self.isComesFromEdit ? "Employee record updated" : "Employee has been created sucessfully") , completionOnButton: {
                let vc = UpdateEmplyoeeSteppThreeVC.instantiateFrom(storyboard: .employee)
                vc.staffCode = self.staffCode
                vc.staffMember = self.staffMember
                vc.isComesFromEdit = self.isComesFromEdit
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    private func getSelectedValueForAllowedOption(allowedOption: AllowedOption) -> Bool {
        let filtered = arrAllowedOption.filter{$0.0 == allowedOption}.first
        if let isSelected = filtered?.1 {
            return isSelected ? true : false
        }
        return false
    }

    private func getIndexForAllowedOption(allowedOption: AllowedOption) -> Int? {
        let index = arrAllowedOption.firstIndex(where: { ($0.0 == allowedOption)})
        return index
    }
    // MARK: DatePicker Delegate
    @objc func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        txtFldJointDate.text = formatter.string(from: sender.date)
    }
}
