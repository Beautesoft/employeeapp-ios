//
//  CreateWorkScheduleVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

protocol WorkScheduleData {
    func workScheduleData(workscheduleId:String,startDate:String,endDate:String)
}

class CreateWorkScheduleVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    var activeFieldTag: Int = 0
    
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet weak var txtFldSelectOption: UITextField!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var endDateTF: UITextField!
    @IBOutlet var selectWorkTF: UITextField!
    @IBOutlet var startDateTF: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var nameTF: UITextField!
    
    
    var isComeFrom:Bool = false
    var scheduleDict:[String:Any] = [:]
    var workScdeuleDelegate:WorkScheduleData!
    var scheduledListModel: ScheduledList?
    var datePicker =  UIDatePicker()
    let toolBar = UIToolbar()
    var picker =  UIPickerView()
    var workScheduleArr:[String]=["Type1","Type2","Type 3"]
    var workscheduleTypeArrDict:[[String:Any]] = []
    var arrWorkScheduledType = [WorkScheduleTypes]()
    var staffMember: StaffMember?
    var arrOptionList = [WorkScheduleOptionList]()
    var pickerViewTypes = UIPickerView()
    var pickerVwSiteListing = UIPickerView()
    var scheduleTypeCode:String = ""
    var siteListingCode: String = ""
    var isComeFromUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        if let role = profile.role, role == .staff {
            nameTF.text = "\(profile.firstName ?? "")\(profile.lastName ?? "")"
        }else {
            nameTF.text = "\(staffMember?.firstName ?? "")\(staffMember?.lastName ?? "")"
        }
        if isComeFromUpdate {
            headerLbl.text = "UPDATE WORK SCHEDULE"
            createBtn.setTitle("Update", for: .normal)
            siteListingCode = scheduledListModel?.siteCode ?? ""
            let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy/MM/dd", toFormat: "E, dd/MM/yyyy", dateString: scheduledListModel?.startDate ?? "")
            let endDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy/MM/dd", toFormat: "E, dd/MM/yyyy", dateString: scheduledListModel?.endDate ?? "")

            startDateTF.text = startDate
            endDateTF.text = endDate
            scheduleTypeCode = scheduledListModel?.scheduleType ?? ""
            commentsTextView.text = scheduledListModel?.comments ?? ""
            txtFldSelectOption.text = scheduledListModel?.siteName ?? ""
            selectWorkTF.text = scheduledListModel?.title ?? ""
            commentsTextView.textColor = UIColor.darkGray
        }else {
            headerLbl.text = "CREATE WORK SCHEDULE"
            createBtn.setTitle("Create", for: .normal)
            commentsTextView.textColor = UIColor.lightGray
        }
        
        setDatePicker()
        setPicker()
        getWorkScheduleType()
    }
    //GetDepartment List
    func getSiteListingTypeType() {
        let url = "\(base)\(Apis.staffSiteListing)\(staffMember?.siteCode ?? "")&staffCode=\(staffMember?.staffCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
             self.arrOptionList.removeAll()
            if let result = response["result"] as? [[String: Any]] {
               
                result.forEach({ (dict) in
                    self.arrOptionList.append(WorkScheduleOptionList(fromDictionary: dict))
                })
            }
        }
    }
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func createBtnTap(_ sender: Any) {
        var dict:[String:Any] = [:]
//        _ = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd hh:mm:ss", toFormat: "yyyy/MM/dd hh:mm:ss", dateString: startDateTF.text ?? "")
//        _ = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd hh:mm:ss", toFormat: "yyyy/MM/dd hh:mm:ss", dateString: endDateTF.text ?? "")
//
//        let startdate = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy/MM/dd hh:mm:ss", toFormat: "yyyy/MM/dd", dateString: startDateTF.text ?? "")
//        let endDate = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy/MM/dd hh:mm:ss", toFormat: "yyyy/MM/dd", dateString: endDateTF.text ?? "")
        
        if siteListingCode == ""{
            singleButtonAlertWith(message: .custom("Please select site listing."))
        }else if startDateTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select start date."))
        }else if selectWorkTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select work schedule type."))
        }else if endDateTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select end date."))
        }else if commentsTextView.text == "Write a comment" || commentsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.singleButtonAlertWith(message: .custom("Please enter your comment"), button: .ok)
        }
        else {
            if isComeFromUpdate {
               updateWorkSchedule()
                return
            }
            let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "E, dd/MM/yyyy", toFormat: "yyyy/MM/dd", dateString: startDateTF.text ?? "")
            let endDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "E, dd/MM/yyyy", toFormat: "yyyy/MM/dd", dateString: endDateTF.text ?? "")
            let parameter = [
                "siteCode": siteListingCode,
                "userID": profile.userID ?? "",
                "staffCode": staffMember?.staffCode ?? "",
                "title": selectWorkTF.text ?? "",
                "startDate": startDate,
                "endDate": endDate,
                "comments": commentsTextView.text.trimmingCharacters(in: .whitespaces),
                "scheduleType": scheduleTypeCode
            ]
            //Apr 19, 2019
            // MMMM dd yyyy
            print(parameter)
            dict = parameter
            var actionUrl = String()
            actionUrl = "\(base)\(Apis.createWorkSchedule)"
            WebService.shared.postDataFor(api: actionUrl, parameters: dict as [String : AnyObject]) { (sucess, response, msg) in
                self.singleButtonAlertWith(message: .custom("Work has been scheduled sucessfully" ) , completionOnButton: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    private func updateWorkSchedule() {
        let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "E, dd/MM/yyyy", toFormat: "yyyy/MM/dd", dateString: startDateTF.text ?? "")
        let endDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "E, dd/MM/yyyy", toFormat: "yyyy/MM/dd", dateString: endDateTF.text ?? "")
        let startTime  = Utility.shared.formattedStringFromGivenDate(fromFormat: "E, dd/MM/yyyy", toFormat: "yyyy/MM/dd h:mm", dateString: startDateTF.text ?? "")
        let endTime  = Utility.shared.formattedStringFromGivenDate(fromFormat: "E, dd/MM/yyyy", toFormat: "yyyy/MM/dd h:mm", dateString: endDateTF.text ?? "")

        let parameter1 = [
            "scheduleID": scheduledListModel?.scheduleID ?? "",
            "siteCode": siteListingCode,
            "userID": profile.userID ?? "",
            "managerID": scheduledListModel?.managerID ?? "",
            "title": scheduleTypeCode,
            "startDate": startDate,
            "endDate": endDate
        ]

       let url = "\(base)\(Apis.updateWorkSchedule)"
        WebService.shared.postDataFor(api: url, parameters: parameter1 as [String : AnyObject]) { (sucess, response, msg) in
            self.singleButtonAlertWith(message: .custom("Work Scheduled has been updated sucessfully" ) , completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func goToBackVC(){
        self.navigationController?.popViewController(animated: true)
    }
    func getWorkScheduleType(){
        let siteCodeStr =  staffMember?.siteCode ?? ""
        let url = "\(base)\(Apis.getWorkScheduleType)\(siteCodeStr)"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrWorkScheduledType.append(WorkScheduleTypes(fromDictionary: dict))
                })
            }
        }
        self.getSiteListingTypeType()
    }
    // SET PICKER
    func setPicker(){
        picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        selectWorkTF.inputView = picker
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: "donePicker")
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        selectWorkTF.inputAccessoryView = toolBar
    }
    
    // SET PICKER
    func setDatePicker(){
        datePicker = UIDatePicker(frame: CGRect(x:0, y:200, width:view.frame.width,height: 216))
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(CreateWorkScheduleVC.datePickerChanged(_:)), for: .valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print(selectedDate)
        startDateTF.inputView = datePicker
        endDateTF.inputView = datePicker
        
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

        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        startDateTF.inputAccessoryView = toolBar
        endDateTF.inputAccessoryView = toolBar
    }
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView ==  pickerViewTypes{
            return arrWorkScheduledType.count
        }else if pickerView ==  pickerVwSiteListing{
            return arrOptionList.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView ==  pickerViewTypes{
            let selectedcategory = arrWorkScheduledType[row].itemDesc ?? ""
            return selectedcategory
        }else if pickerView ==  pickerVwSiteListing{
            let selectedcategory = arrOptionList[row].itemDesc ?? ""
            return selectedcategory
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if pickerView ==  pickerViewTypes{
            let categoryList = arrWorkScheduledType[row]
            selectWorkTF.text = categoryList.itemDesc
            scheduleTypeCode =  categoryList.itemCode
            self.view.endEditing(true)
        }else if pickerView ==  pickerVwSiteListing{
            let categoryList = arrOptionList[row]
            txtFldSelectOption.text = categoryList.itemDesc
            siteListingCode =  categoryList.itemCode
            self.view.endEditing(true)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeFieldTag = textField.tag
        return true
    }
   //"yyyy/MM/dd"
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd/MM/yyyy"
        //dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        //dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        if activeFieldTag == 101{
            startDateTF.text = strDate
        }else{
            endDateTF.text = strDate
        }
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func donePicker(){
        self.view.endEditing(true)
    }
}
extension CreateWorkScheduleVC: UITextFieldDelegate {
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerVwSiteListing.delegate = self
        pickerVwSiteListing.dataSource  = self
        pickerVwSiteListing.reloadAllComponents()
        
        pickerViewTypes.delegate = self
        pickerViewTypes.dataSource  = self
        pickerViewTypes.reloadAllComponents()
        
        if textField == txtFldSelectOption {
            txtFldSelectOption.inputView = pickerVwSiteListing
            if txtFldSelectOption.text == "" {
                let row = pickerVwSiteListing.selectedRow(inComponent: 0)
                let model = arrOptionList[row]
                let industryType = model.itemDesc
                siteListingCode = model.itemCode
                txtFldSelectOption.text = industryType
            }
        }else if textField == selectWorkTF {
            selectWorkTF.inputView = pickerViewTypes
            if selectWorkTF.text == "" {
                let row = pickerViewTypes.selectedRow(inComponent: 0)
                let model = arrWorkScheduledType[row]
                let industryType = model.itemDesc
                scheduleTypeCode = model.itemCode
                selectWorkTF.text = industryType
            }
        }
    }
}
extension CreateWorkScheduleVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == commentsTextView{
            if textView.text == "Write a comment"{
                textView.text = ""
                textView.textColor = UIColor.darkText
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == commentsTextView{
            if textView.text == "" {
                textView.text = "Write a comment"
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
