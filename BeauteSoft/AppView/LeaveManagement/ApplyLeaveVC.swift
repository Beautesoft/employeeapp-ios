//
//  ApplyLeaveVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/18/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class ApplyLeaveVC: UIViewController{
    
    @IBOutlet var endDateTF: UITextField!
    @IBOutlet var startDateTF: UITextField!
    @IBOutlet var endPeriodTF: UITextField!
    @IBOutlet var startPeriodTF: UITextField!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var messageTxtView: UITextView!
    @IBOutlet var leaveTypeTF: UITextField!
    
    let imagePicker = UIImagePickerController()
    var imageData:Data?
    var pic:UIImage!
    var arrSession:[String] = ["Full day","Morning","Afternoon"]
    var datePicker = UIDatePicker()
    var datePickerEndDate = UIDatePicker()
    var arrLeavesTypes = [LeaveTypes]()
    var pickerVwLeaves = UIPickerView()
    var selectedLeaveCode: String?
    var pickerVwDay = UIPickerView()
    var isSelectedImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
            datePickerEndDate.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
                datePickerEndDate.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }

        }
        startDateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        
        endDateTF.inputView = datePickerEndDate
        datePickerEndDate.datePickerMode = .date
        
        messageTxtView.text = "Write a message"
        messageTxtView.textColor = UIColor.lightGray
        
        getLeaveTypes()
    }
    
    // MARK: DatePicker Delegate
    @objc func datePickerChangedStartDate(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        startDateTF.text = formatter.string(from: sender.date)
    }
    @objc func datePickerChangedEndDate(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        endDateTF.text = formatter.string(from: sender.date)
    }
    //MARK: button action
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPhotoBtnTap(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func submitBtnTap(_ sender: Any) {
        if leaveTypeTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select leave type."))
        }else if startDateTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select start date."))
        }else if startPeriodTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select start day period."))
        }else if endDateTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select end date."))
        }else if endPeriodTF.text == ""{
            singleButtonAlertWith(message: .custom("Please select end day period."))
        }else if messageTxtView.text == "Write a message" || messageTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.singleButtonAlertWith(message: .custom("Please add some message"), button: .ok)
        }else if self.compareTwoDates(firstDate: startDateTF.text ?? "", secondDate: endDateTF.text ?? "") == false {
             singleButtonAlertWith(message: .custom("End date should be greather then first date."))
        }else if !isSelectedImage {
            singleButtonAlertWith(message: .custom("Please select leave image."))
        }else {
            applyLeaveApi()
        }
    }
    
    func applyLeaveApi(){
        let noOfDays = calculateNoOfDaysBetweenTwoDates(firstDate: startDateTF.text ?? "", secondDate: endDateTF.text ?? "")
        let josnDict = Utility.shared.json(from: ["staffCode": "","siteCode":profile.siteCode ?? "","noOfDays": "\(noOfDays + 1)","leaveType":leaveTypeTF.text ?? "","startPeriod":startPeriodTF.text ?? "","endPeriod":endPeriodTF.text!,"startDate":startDateTF.text ?? "","endDate":endDateTF.text ?? "","message":messageTxtView.text ?? "","userID": profile.userID ?? ""])
        let params = ["jsonKey":josnDict ?? ""] as [String : AnyObject]
        let url = "\(base)\(Apis.applyLeave)"
        let imgdict = ["file": imgView.image?.jpegData(compressionQuality: 0.6) ?? Data()]
        WebService.shared.uploadMediaToServer(api: url, imgMedia: imgdict , parameters: params) { (sucess, result, msg) in
            self.singleButtonAlertWith(message: .custom("Leave has been create sucessfully."), completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            } )
        }
    }
    private func getLeaveTypes() {
        let url = "\(base)\(Apis.getLeaveType)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if sucess {
                if let result = response["result"] as? [[String:Any]]{
                    result.forEach({ (dictionary) in
                        self.arrLeavesTypes.append(LeaveTypes(fromDictionary: dictionary))
                    })
                }
            }
        }
    }
    
    //PICKER VIEW DELEGATES AND DATASPURCES
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerVwLeaves {
            return arrLeavesTypes.count
        }else if pickerView == pickerVwDay {
            return arrSession.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerVwLeaves {
            let model = arrLeavesTypes[row]
            return model.itemDesc
        }else if pickerView == pickerVwDay {
            return arrSession[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerVwLeaves {
            let model = arrLeavesTypes[row]
            leaveTypeTF.text = model.itemDesc
            selectedLeaveCode = model.itemCode
        }else if pickerView == pickerVwDay {
            startPeriodTF.text = arrSession[row]
        }
    }
    private func compareTwoDates(firstDate: String, secondDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let firstDate = formatter.date(from: firstDate)
        let secondDate = formatter.date(from: secondDate)
        
        if firstDate?.compare(secondDate!) == .orderedSame {
            return true
        }else if firstDate?.compare(secondDate!) == .orderedAscending {
            return true
        }else {
            return false
        }
    }
    private func calculateNoOfDaysBetweenTwoDates(firstDate: String, secondDate: String) -> Int{
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let firstDate = formatter.date(from: firstDate)!
        let secondDate = formatter.date(from: secondDate)

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate!)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
extension ApplyLeaveVC: UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerVwLeaves.delegate = self
        pickerVwLeaves.dataSource  = self
        pickerVwLeaves.reloadAllComponents()
        
        pickerVwDay.delegate = self
        pickerVwDay.dataSource  = self
        pickerVwDay.reloadAllComponents()
        
        if textField == startDateTF {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            startDateTF.text = formatter.string(from: datePicker.date)
            datePicker.addTarget(self, action: #selector(datePickerChangedStartDate(sender:)
                ), for: .valueChanged)
        }else if textField == endDateTF {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            endDateTF.text = formatter.string(from: datePickerEndDate.date)
            datePickerEndDate.addTarget(self, action: #selector(datePickerChangedEndDate(sender:)
                ), for: .valueChanged)
        }else if textField == leaveTypeTF {
            leaveTypeTF.inputView = pickerVwLeaves
            if leaveTypeTF.text == "" {
                let row = pickerVwLeaves.selectedRow(inComponent: 0)
                let model = arrLeavesTypes[row]
                leaveTypeTF.text = model.itemDesc
                selectedLeaveCode = model.itemCode
            }
        }else if textField == startPeriodTF {
            startPeriodTF.inputView = pickerVwDay
            if startPeriodTF.text == "" {
                let row = pickerVwDay.selectedRow(inComponent: 0)
                startPeriodTF.text = arrSession[row]
            }
        }else if textField == endPeriodTF {
            endPeriodTF.inputView = pickerVwDay
            if endPeriodTF.text == "" {
                let row = pickerVwDay.selectedRow(inComponent: 0)
                endPeriodTF.text = arrSession[row]
            }
        }
    }
}
extension ApplyLeaveVC: UITextViewDelegate {
    //UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a message"
            textView.textColor = UIColor.lightGray
        }else{
            messageTxtView.text = textView.text
        }
        // self.view.endEditing(true)
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
}
