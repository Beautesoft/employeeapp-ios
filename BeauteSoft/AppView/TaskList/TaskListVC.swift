//
//  TaskListVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/4/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class taskListCell:UITableViewCell{
    @IBOutlet var takslistTitleLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet weak var lblPrority: UILabel!
}

class TaskListVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,SendFilterData {
    
    var empDataDict:[String:Any] = [:]
    var isComeFromEmpManagement:Bool = false
    @IBOutlet var tableView: UITableView!
    @IBOutlet var openTF: UITextField!
    @IBOutlet var chooseDateTF: UITextField!
    @IBOutlet var allTf: UITextField!
    @IBOutlet weak var btnCreateTask: UIButton!
   
    var taskListArrDict:[[String:Any]] = []
    var staffId:String = ""
    var deptId:String = ""
    var status:String = ""
    var slectedDate:String = ""
    var siteListingFilterCode: String = ""
    var statusArr:[TaskStatus] = [.accepted,.confirmed,.completed,.cancelled,.pending,.open, .deleted]
    var picker =  UIPickerView()
    var datePicker =  UIDatePicker()
    var arrTaskList = [TaskList]()
    var screenOpenFromEmployeeManagement = false
    
    var selectedViewTypeValue: ViewType = .createdByMe
    var taskType:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        status  = "Open"
        if let role = profile.role, role == .manager {
            selectedViewTypeValue = .createdByMe
            btnCreateTask.isHidden = false
        } else {
            selectedViewTypeValue = .assignedToMe
            btnCreateTask.isHidden = true
        }
        setPicker()
        setDatePicker()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GlobalBaseClass.departmentServiceId = ""
        getTaskListApi()
    }
    
    func sendFilterData(siteListingID: String, deptID: String, status: String, seletedDate: String,viewType: ViewType,taskType: String) {
        self.taskType = taskType
        self.selectedViewTypeValue = viewType
        siteListingFilterCode = siteListingID
        self.status = status == "" ? "Open" : status
        deptId = deptID
        self.slectedDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "yyyy/MM/dd", dateString: seletedDate)
        //  self.slectedDate = seletedDate
        //staffId == "" ? "Open" :
        getTaskListApi()
    }
    
    @IBAction func actionAll(_ sender: Any) {
        status  = "Open"
        getTaskListApi()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell") as! taskListCell
        cell.selectionStyle = .none
        let taskList = arrTaskList[indexPath.row]
        if taskList.taskTitle == "" {
            cell.takslistTitleLbl.text = taskList.taskDescription
        }else {
            cell.takslistTitleLbl.text = taskList.taskTitle
        }
        cell.dateLbl.text = taskList.taskType ?? ""
        let appointmentDate = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy", dateString: taskList.appointmentDate ?? "")
        let appointmentStartTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "h:mm a", dateString: taskList.appointmentStartTime ?? "")
        let appointmentEndTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "dd MMM yyyy  h:mm a", dateString: taskList.appointmentEndTime ?? "")

      //  if (taskList.taskType == TaskTypes.appointment.rawValue) || (taskList.taskType == TaskTypes.walkIn.rawValue) || (taskList.taskType == TaskTypes.external.rawValue){
          cell.timeLbl.text = "\(appointmentDate)  \(appointmentStartTime) - \(appointmentEndTime)"
        cell.lblPrority.text = "Priority:  \(taskList.priority ?? "")"
        cell.lblPrority.setTextColor(color: .red, string: taskList.priority ?? "")
        if taskList.status == TaskStatus.accepted.rawValue || taskList.status == TaskStatus.pending.rawValue {
            cell.lblPrority.isHidden = false
        }else {
            cell.lblPrority.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if selectedViewTypeValue == .createdByMe {
            let taskList = arrTaskList[indexPath.row]
            if !(taskList.taskType == TaskTypes.outletRequest.rawValue) {
                let vc = TaskDetailVC.instantiateFrom(storyboard: .taskManagement)
                vc.taskListModel = arrTaskList[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
         }else {
            let vc = StaffMemberTaskDetailVC.instantiateFrom(storyboard: .taskManagement)
            vc.taskId = arrTaskList[indexPath.row].taskId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // SET PICKER
    func setPicker(){
        
        picker = UIPickerView(frame: CGRect(x:0, y:200, width:view.frame.width,height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        openTF.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePickerStatus")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePickerStatus")))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        openTF.inputAccessoryView = toolBar
        
    }
    
    func getTaskListApi(){
        let parameter: [String : AnyObject]?
        if selectedViewTypeValue == .createdByMe {
            parameter = ["userID": profile.userID ?? "","status":status,"siteCode":profile.siteCode,"departmentID": deptId,"staffCode": "","date":slectedDate,"assignedsiteCode": siteListingFilterCode,"taskType": taskType] as [String : AnyObject]
        }else {
            parameter = ["userID": "","status":status,"siteCode":profile.siteCode ?? "","departmentID": deptId,"staffCode": profile.staffCode ?? "","date":slectedDate,"assignedsiteCode": siteListingFilterCode,"taskType": taskType] as [String : AnyObject]
        }
//        if let role = profile.role, role == .staff {
//             parameter = ["userID": "","status":status,"siteCode":profile.siteCode ?? "","departmentID": deptId,"staffCode": profile.staffCode ?? "","date":slectedDate,"assignedsiteCode": siteListingFilterCode] as [String : AnyObject]
//        }else {
//             parameter = ["userID": profile.userID ?? "","status":status,"siteCode":profile.siteCode,"departmentID": deptId,"staffCode": "","date":slectedDate,"assignedsiteCode": siteListingFilterCode] as [String : AnyObject]
//        }
        let url = "\(base)\(Apis.getTaskList)"
        WebService.shared.postDataFor(api: url, parameters: parameter) { (scuess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                self.arrTaskList.removeAll()
                result.forEach({ (dict) in
                    self.arrTaskList.append(TaskList(fromDictionary: dict))
                })
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func filterBtnTap(_ sender: Any) {
        let vc = FilterVC.instantiateFrom(storyboard: .taskManagement)
        vc.selectedviewType = selectedViewTypeValue
        vc.filterDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func plusBtnTap(_ sender: Any) {
        let vc = TaskCreationVC.instantiateFrom(storyboard: .taskManagement)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // SET PICKER
    func setDatePicker(){
        
        datePicker = UIDatePicker(frame: CGRect(x:0, y:200, width:view.frame.width,height: 216))
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
        chooseDateTF.inputView = datePicker
        
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
        
        chooseDateTF.inputAccessoryView = toolBar
        
    }
    @objc func donePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        slectedDate = formatter.string(from: datePicker.date)
        formatter.dateFormat = "dd MMM yyyy"
        chooseDateTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        getTaskListApi()
    }
    @objc func donePickerStatus(){
        let list =  self.statusArr[0].rawValue
        openTF.text = list
        self.status = list
        self.view.endEditing(true)
        getTaskListApi()
    }

    //PICKER VIEW DELEGATES AND DataSources
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  self.statusArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedcategory = statusArr[row].rawValue
        return selectedcategory
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        let list =  self.statusArr[row].rawValue
        openTF.text = list
        self.status = list
        self.view.endEditing(true)
        getTaskListApi()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
