//
//  UpdateEmployeeVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/10/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class employeInfoCell:UITableViewCell{
    @IBOutlet var infoTF: UITextField!
}

class EmployeeDateCell:UITableViewCell{
    @IBOutlet var dateTF: UITextField!
}
class ManualEntryCell:UITableViewCell{
    @IBOutlet var entryTF: UITextField!
}
class OptionCell:UITableViewCell{
    @IBOutlet var entryTF: UITextField!
}
class employeeImgCell:UITableViewCell{
    @IBOutlet var imgView: UIImageView!
}
class submitInfocell:UITableViewCell{
    
}
class SelectOptionCell:UITableViewCell{
    @IBOutlet var selectOptionTF: UITextField!
}
class UpdateEmployeeVC: UIViewController,UITableViewDelegate,SiteListingOptionDelegate{
    
    @IBOutlet weak var imgEmployee: UIImageView!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldContact: UITextField!
    @IBOutlet weak var txtFldPassportNo: UITextField!
    @IBOutlet weak var txtFldDisplayName: UITextField!
    @IBOutlet weak var txtFldDob: UITextField!
    @IBOutlet weak var txtFldContactPerson: UITextField!
    @IBOutlet weak var txtFldContactNumber: UITextField!
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var txtFldgender: UITextField!
    @IBOutlet weak var txtFldRaces: UITextField!
    @IBOutlet weak var txtFldNationality: UITextField!
    @IBOutlet weak var txtFldReligion: UITextField!
    @IBOutlet weak var txtFldMaritialStatus: UITextField!
    @IBOutlet weak var txtFldEmployeeType: UITextField!
    @IBOutlet weak var txtFldSiteListing: UITextField!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    var imageData:Data?
    var pic:UIImage!
    var isComingFrom:Bool = false
    var activeFieldTag: Int = 0
    var parameterDict :[String:Any] = [:]
    var siteCodeStr:String = ""
    var arrGenderList = [GenderList]()
    var arrRace = [RaceList]()
    var arrNationality = [NationalityList]()
    var arrReligion = [ReligionList]()
    var arrMaritalStatus = [MartialLsit]()
    var arrEmployeeType = ["Admin","Staff"]
    var arrSiteListing = [SiteListingOption]()
    var pickerVwGender = UIPickerView()
    var pickerVwRaces = UIPickerView()
    var pickerVwNationality = UIPickerView()
    var pickerVwReligion = UIPickerView()
    var pickerVwMaritial = UIPickerView()
    var pickerVwEmployeeType = UIPickerView()
    var pickerVwSiteListing = UIPickerView()
    var datePicker = UIDatePicker()
    
    var siteListingId: String?
    var genderCode: String?
    var racedId: String?
    var nationlityCode: String?
    var relegionCode: String?
    var martialStatusCode: String?
    var selectedGenderCode: String?
    var employeeStr: String?
    var selectedSiteListing: [[String:Any]] = []
    var isEmpImageSelected = false
    var isSiteListingSelected = false
    var staffMember: StaffMember?
    var isComesFromUpdate = false
    //var vc =  SiteListingOptionsVC.instantiateFrom(storyboard: .siteManagement)
    var vc =  SiteListingOptionsVC.instantiateFrom(storyboard: .siteManagement)
    //var vc =  UpdateEmployeeVC.instantiateFrom(storyboard: .employee)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        vc.delegate = self

        txtFldDob.delegate = self
        txtFldDob.inputView = datePicker
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

        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Calendar.current.date(from: DateComponents( year: 1900, month: 1, day: 1))
        navigationTitleLbl.text = "Create New Employee"
        siteCodeStr =  profile.siteCode ?? ""
        getGender()
        if isComesFromUpdate {
          showData()
           navigationTitleLbl.text = "Update Employee"
        }
    }
    private func showData() {
        isEmpImageSelected = true
        imgEmployee.sd_setImage(with: URL(string: staffMember?.profilePic ?? ""), placeholderImage: UIImage(named: "member_icon"))
        txtFldFirstName.text = staffMember?.firstName ?? ""
        txtFldLastName.text = staffMember?.lastName ?? ""
        txtFldEmail.text = staffMember?.email ?? ""
        txtFldContact.text = staffMember?.contact ?? ""
        txtFldPassportNo.text = staffMember?.nric ?? ""
        txtFldDisplayName.text = staffMember?.displayName ?? ""
        txtFldDob.text = staffMember?.dob ?? ""
        txtFldContactPerson.text = staffMember?.emerContactPerson ?? ""
        txtFldContactNumber.text = staffMember?.emerContactNo ?? ""
        txtFldAddress.text = staffMember?.address ?? ""
        txtFldgender.text = staffMember?.genderName ?? ""
        txtFldRaces.text = staffMember?.raceName ?? ""
        txtFldNationality.text = staffMember?.nationalityName ?? ""
        txtFldReligion.text = staffMember?.religionName ?? ""
        txtFldMaritialStatus.text = staffMember?.maritalName ?? ""
        txtFldEmployeeType.text = staffMember?.empType == "0" ? "Admin" : "Staff"
        selectedGenderCode = staffMember?.gender ?? ""
        racedId = staffMember?.races ?? ""
        nationlityCode = staffMember?.nationality ?? ""
        relegionCode = staffMember?.religion ?? ""
        martialStatusCode = staffMember?.maritalStatus ?? ""
        txtFldSiteListing.text = staffMember?.siteCode == "SL01" ? "OUTLET A" : "OUTLET B"
        selectedSiteListing =  Utility.shared.getSiteListingParameter(siteListing: staffMember?.siteListing)
    }
    func didSelectedSites(with result: [SiteListingOption]) {
        selectedSiteListing =  Utility.shared.getSiteListingParameter(siteListingOption: result)
        txtFldSiteListing.text = result.last?.itemDesc ?? ""
    }
    //Button Action
    @IBAction func actionNext(_ sender: Any) {
        setValidation()
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSiteListing(_ sender: Any) {
        vc.screenOpenedFrom = .createEmployee
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func submitBtnTap(_ sender: Any) {
        setValidation()
    }
    @IBAction func uploadImgBtnTap(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        initiateImagePicker(imagePicker, isVideo: false, editingAllowed: true)
    }
    
    func setValidation(){
        if !isEmpImageSelected {
            self.singleButtonAlertWith(message: .custom("Please select employee image"))
        }else if txtFldFirstName.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter first name"))
        }else if txtFldLastName.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter last name"))
        }else if txtFldDisplayName.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter display name"))
        }else if txtFldEmail.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter email"))
        }else if !Validator.isValid(email: txtFldEmail.text ?? "") {
            self.singleButtonAlertWith(message: .custom("Please enter valid email"))
        }else if txtFldAddress.isBlank {
            self.singleButtonAlertWith(message: .custom("Please enter address"))
        }else if txtFldgender.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select gender"))
        }else if txtFldRaces.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select races"))
        }else if txtFldNationality.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select nationality"))
        }else if txtFldReligion.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select religion"))
        }else if txtFldMaritialStatus.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select maritialStatus"))
        }else if txtFldEmployeeType.isBlank {
            self.singleButtonAlertWith(message: .custom("Please select employee type"))
        }else if selectedSiteListing.count == 0 {
            self.singleButtonAlertWith(message: .custom("Please select site listing"))
        }else {
            parameterDict.updateValue(txtFldFirstName.text ?? "", forKey: "firstName")
            parameterDict.updateValue(txtFldLastName.text ?? "", forKey: "lastName")
            parameterDict.updateValue(txtFldEmail.text ?? "", forKey: "email")
            parameterDict.updateValue(txtFldContact.text ?? "", forKey: "contact")
            parameterDict.updateValue(txtFldPassportNo.text ?? "", forKey: "nric")
            parameterDict.updateValue(txtFldDisplayName.text ?? "", forKey: "displayName")
            parameterDict.updateValue(txtFldDob.text ?? "", forKey: "dob")
            parameterDict.updateValue(txtFldContactPerson.text ?? "", forKey: "emerContactPerson")
            parameterDict.updateValue(txtFldContactNumber.text ?? "", forKey: "emerContactNo")
            parameterDict.updateValue(txtFldAddress.text ?? "", forKey: "address")
            parameterDict.updateValue(selectedGenderCode ?? "", forKey: "gender")
            parameterDict.updateValue(racedId ?? "", forKey: "races")
            parameterDict.updateValue(nationlityCode ?? "", forKey: "nationality")
            parameterDict.updateValue(relegionCode ?? "", forKey: "religion")
            parameterDict.updateValue(martialStatusCode ?? "", forKey: "maritalStatus")
            parameterDict.updateValue(employeeTypeCode ?? "", forKey: "empType")
            parameterDict.updateValue(selectedSiteListing, forKey: "SiteListing")
            parameterDict.updateValue("1", forKey: "isactive")
            let vc = CreateEmployeeVC.instantiateFrom(storyboard: .employee)
            vc.paramDict = parameterDict
            vc.staffMember = staffMember
            vc.employeeImage = imgEmployee
            vc.isComesFromEdit = isComesFromUpdate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //Picker View
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerVwGender {
            return arrGenderList.count
        }else if pickerView == pickerVwRaces {
            return  self.arrRace.count
        }else if pickerView == pickerVwNationality {
            return  arrNationality.count
        }else if pickerView == pickerVwReligion {
            return  arrReligion.count
        }else if pickerView == pickerVwMaritial {
            return  arrMaritalStatus.count
        }else if pickerView == pickerVwEmployeeType {
            return  arrEmployeeType.count
        }else if pickerView == pickerVwSiteListing {
            return  self.arrSiteListing.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerVwGender {
            return arrGenderList[row].itemDesc
        }else if pickerView == pickerVwRaces {
            let model = arrRace[row]
            return model.itemDesc
        }else if pickerView == pickerVwNationality {
            let model = arrNationality[row]
            return model.itemDesc
        }else if pickerView == pickerVwReligion {
            let model =  arrReligion[row]
            return model.itemDesc
        }else if pickerView == pickerVwMaritial {
            let model =  arrMaritalStatus[row]
            return model.itemDesc
        }else if pickerView == pickerVwEmployeeType {
            return  arrEmployeeType[row]
        }else if pickerView == pickerVwSiteListing {
            let model = arrSiteListing[row]
            return model.itemDesc
        }
        return ""
    }
    var employeeTypeCode: String?
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if pickerView == pickerVwGender {
            let model = arrGenderList[row]
            txtFldgender.text = model.itemDesc
            selectedGenderCode = model.itemCode
        }else if pickerView == pickerVwRaces {
            let model = arrRace[row]
            txtFldRaces.text = model.itemDesc
            racedId = model.itemCode
        }else if pickerView == pickerVwNationality {
            let model = arrNationality[row]
            txtFldNationality.text = model.itemDesc
            nationlityCode = model.itemCode
        }else if pickerView == pickerVwReligion {
            let model =  arrReligion[row]
            txtFldReligion.text = model.itemDesc
            relegionCode = model.itemCode
        }else if pickerView == pickerVwMaritial {
            let model =  arrMaritalStatus[row]
            txtFldMaritialStatus.text = model.itemDesc
            martialStatusCode = model.itemCode
        }else if pickerView == pickerVwEmployeeType {
            txtFldEmployeeType.text =  arrEmployeeType[row]
            employeeTypeCode = txtFldEmployeeType.text == "Admin" ? "0" : "1"
        }else if pickerView == pickerVwSiteListing {
            let model = arrSiteListing[row]
            txtFldSiteListing.text = model.itemDesc
            selectedGenderCode = model.itemCode
        }
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeFieldTag = textField.tag
        return true
    }
    // MARK: DatePicker Delegate
    @objc func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        txtFldDob.text = formatter.string(from: sender.date)
    }
    //UITextFieldDelegate
    var addressStr:String = ""
    
}
extension UpdateEmployeeVC: UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerVwGender.delegate = self
        pickerVwGender.dataSource  = self
        pickerVwGender.reloadAllComponents()
        
        pickerVwRaces.delegate = self
        pickerVwRaces.dataSource  = self
        pickerVwRaces.reloadAllComponents()
        
        pickerVwNationality.delegate = self
        pickerVwNationality.dataSource  = self
        pickerVwNationality.reloadAllComponents()
        
        pickerVwReligion.delegate = self
        pickerVwReligion.dataSource  = self
        pickerVwReligion.reloadAllComponents()
        
        pickerVwMaritial.delegate = self
        pickerVwMaritial.dataSource  = self
        pickerVwMaritial.reloadAllComponents()
        
        pickerVwEmployeeType.delegate = self
        pickerVwEmployeeType.dataSource  = self
        pickerVwEmployeeType.reloadAllComponents()
        
        pickerVwSiteListing.delegate = self
        pickerVwSiteListing.dataSource  = self
        pickerVwSiteListing.reloadAllComponents()
        
        
        if textField == txtFldDob {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            txtFldDob.text = formatter.string(from: datePicker.date)
            datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)
                ), for: .valueChanged)
        }else if textField == txtFldgender {
            txtFldgender.inputView = pickerVwGender
            if txtFldgender.text == "" {
                let row = pickerVwGender.selectedRow(inComponent: 0)
                let gender = arrGenderList[row]
                txtFldgender.text = gender.itemDesc
                selectedGenderCode = gender.itemCode
            }
        }else if textField == txtFldRaces {
            txtFldRaces.inputView = pickerVwRaces
            if txtFldRaces.text == "" {
                let row = pickerVwRaces.selectedRow(inComponent: 0)
                let races = arrRace[row]
                txtFldRaces.text = races.itemDesc
                racedId = races.itemCode
            }
        }else if textField == txtFldNationality {
            txtFldNationality.inputView = pickerVwNationality
            if txtFldNationality.text == "" {
                let row = pickerVwNationality.selectedRow(inComponent: 0)
                let model = arrNationality[row]
                txtFldNationality.text = model.itemDesc
                nationlityCode = model.itemCode
            }
        }else if textField == txtFldReligion {
            txtFldReligion.inputView = pickerVwReligion
            if txtFldReligion.text == "" {
                let row = pickerVwReligion.selectedRow(inComponent: 0)
                let model = arrReligion[row]
                txtFldReligion.text = model.itemDesc
                relegionCode = model.itemCode
            }
        }else if textField == txtFldMaritialStatus {
            txtFldMaritialStatus.inputView = pickerVwMaritial
            if txtFldMaritialStatus.text == "" {
                let row = pickerVwMaritial.selectedRow(inComponent: 0)
                let model = arrMaritalStatus[row]
                txtFldMaritialStatus.text = model.itemDesc
                martialStatusCode = model.itemCode
            }
        }else if textField == txtFldEmployeeType {
            txtFldEmployeeType.inputView = pickerVwEmployeeType
            if txtFldEmployeeType.text == "" {
                let row = pickerVwEmployeeType.selectedRow(inComponent: 0)
                txtFldEmployeeType.text = arrEmployeeType[row]
            }
        }else if textField == txtFldSiteListing {
            txtFldSiteListing.inputView = pickerVwSiteListing
            if txtFldSiteListing.text == "" {
                let row = pickerVwSiteListing.selectedRow(inComponent: 0)
                let model = arrSiteListing[row]
                txtFldSiteListing.text = model.itemDesc
                siteListingId = model.itemCode
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
