//
//  TaskCreationVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/7/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//



import UIKit
import IQKeyboardManagerSwift
class categoryNameCell:UITableViewCell{
    
    @IBOutlet var customerNameLbl: UILabel!
}

class BankAmountCell:UITableViewCell{
    
    @IBOutlet var bankAmountTF: UITextField!
}

class taskTypeCell:UITableViewCell{
    @IBOutlet var taskTypeTF: UITextField!
}

class taskInfoCell:UITableViewCell{
    @IBOutlet var infoTF: UITextField!
}

class taskDeptCell:UITableViewCell{
    
    @IBOutlet var deptTF: UITextField!
}

class taskStaffNameCell:UITableViewCell{
    @IBOutlet var taskStaffNameTF: UITextField!
}

class taskRequestCell:UITableViewCell{
    
    @IBOutlet var requestTherapySelectBtn: UIButton!
    @IBOutlet var taskReqTF: UITextField!
}
class taskPriorityCell:UITableViewCell{
    @IBOutlet var taskPriorityTF: UITextField!
}
class TaskCreationCell:UITableViewCell{
    @IBOutlet var creationEntryTF: UITextField!
}
class SubmitBtnCell:UITableViewCell{
    
}

class SiteListingCell:UITableViewCell{
    
    @IBOutlet var siteListingTF: UITextField!
}
class selectFilesCell:UITableViewCell{
    
    @IBOutlet var profileImgView: UIImageView!
}

var delegateSelectedServiceType: SelectedServiceType?
class TaskCreationVC: UIViewController,UITableViewDataSource,UITableViewDelegate ,UIPickerViewDelegate,UIPickerViewDataSource,StaffMemberDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectedServiceType{
    
    @IBOutlet weak var lblnavTitle: UILabel!
    @IBOutlet var taskCreationTblView: UITableView!
    @IBOutlet var getCustomerTblView: UITableView!
    @IBOutlet var getCustomerTblHeight: NSLayoutConstraint!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerSuperView: UIView!
    @IBOutlet var tableView: UITableView!
    
    //MY variables
    var selectedCells:[Int] = []
    let imagePicker = UIImagePickerController()
    var imageData:Data?
    var pic:UIImage!
    var customernameStr:String = ""
    var tasktitleStr:String = ""
    var taskDesc:String = ""
    var amountStr:String = ""
    var requestTherapy:String = ""
    var taskDetailInfoDict:[String:Any] = [:]
    var taskIdStr:String = ""
    var siteListingStr:String = ""
    var siteListingId:String = ""
    var priorityField:String = ""
    var changedOutletName = ""
    var changedOutletCode = ""
    var currentOutletName = ""
    var currentOutletCode = ""
    var selectAppointmentDateStr:String = ""
    var selectEndDateStr:String = ""
    var startDateAndTime: String = ""
    var endDateAndTime: String = ""
    var startDateStr:String = ""
    var endDateStr:String = ""
    var activeFieldTag: Int = 0
    var picker =  UIPickerView()
    var priorityArr:[String] = ["Highest","High","Medium","Low"]
    var taskOptionArr: [TaskTypes] = [.appointment, .bankIn, .external, .outletRequest, .walkIn]
    // var arrTaskTypes:[[String:Any]] = []
    var siteListingArr:[[String:Any]] = []
    let toolBar = UIToolbar()
    var selectedTaskType: TaskTypes?
    var taskOptionId:String = ""
    var getCustomerArrDict:[[String:Any]] = []
    var isComeFromUpdate:Bool = false
    var arrTaskTypes = [TaskType]()
    var arrSelectedServiceIds = [String]()
    var selectedDepartmentType: DepartmentList?
    var slectedDepartMentName: String?
    var taskDetail: TaskDetail?
    var isThearpyRequestSelected = false
    var taskImage: String?
    var amontDateFrom1:String = ""
    var amountDateFrom2:String = ""
    var isSelectedImage = false
    var mySiteListing:[[String:Any]] = []
    var arrOptionList = [SiteListingOption]()
    var startTime: String?
    var endTime: String?
    var staffNameStr:String = ""
    var staffCodeStr:String = ""
    var siteCodeStr: String = ""
    var departmentCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateAndTime = ""
        endDateAndTime = ""
        
        delegateSelectedServiceType = self
        setPicker()
        updateTask()
    }
    
//    "Request Parameters: [\"customerName\": ali, \"appointmentDate\": 2019/07/26, \"siteCode\": SL01, \"staffID\": , \"appointmentEndTime\": 2019/07/27 02:01, \"departmentID\": 49, \"serviceIDs\": 34900010,34900001, \"userID\": FRANCIS, \"isRequestTherapist\": 1, \"taskType\": Appointment, \"appointmentStartTime\": 23:01, \"staffCode\": 100040, \"priority\": Highest, \"taskDescription\": gg]"
    private func updateTask() {
        DispatchQueue.main.async {
            self.getTaskType()
        }
        if isComeFromUpdate {
            guard let selectedTask = TaskTypes(rawValue: taskDetail?.taskType.lowercased() ?? "") else {
                return
            }
            lblnavTitle.text = "Edit Task"
            selectedTaskType = selectedTask
            self.customernameStr = taskDetail?.customerName ?? ""
            if selectedTask == .appointment || selectedTask == .appointment{
                self.arrSelectedServiceIds =  taskDetail?.serviceIDs.components(separatedBy: ",") ?? []
                GlobalBaseClass.departmentServiceId = taskDetail?.serviceIDs ?? ""
            }
            siteListingId = taskDetail?.siteCode ?? ""
            staffCodeStr = taskDetail?.staffCode ?? ""
            priorityField = taskDetail?.priority ?? ""
            isThearpyRequestSelected = taskDetail?.isRequestTherapist ?? false ? true : false
             self.selectAppointmentDateStr = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy", dateString: taskDetail?.appointmentDate ?? "")
            let startTimeSending = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "HH:mm", dateString: taskDetail?.appointmentStartTime ?? "")
            // dd/MM/yyyy HH:mm
            self.startDateAndTime = "\(selectAppointmentDateStr) \(startTimeSending)"
          
            self.endDateAndTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "dd MMM yyyy HH:mm", dateString: taskDetail?.appointmentEndTime ?? "")
           
            selectEndDateStr = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "dd MMM yyyy", dateString: taskDetail?.appointmentEndTime ?? "")
            
            let endTimeSending = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "HH:mm", dateString: taskDetail?.appointmentEndTime ?? "")

            //endDateAndTime = taskDetail?.appointmentEndTime ?? ""
            
            
            
            self.startDateStr = startTimeSending
            self.endDateStr = endTimeSending
            let startShowingTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "h:mm a", dateString: taskDetail?.appointmentStartTime ?? "")
            let endShowingTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "h:mm a", dateString: taskDetail?.appointmentEndTime ?? "")
//            let endShowingTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "h:mm a", dateString: taskDetail?.appointmentEndTime ?? "")
            self.startTime = startShowingTime
            self.endTime = endShowingTime
            self.taskDesc = taskDetail?.taskDescription ?? ""
            GlobalBaseClass.departmentId = taskDetail?.departmentID ?? ""
            taskIdStr = taskDetail?.taskID ?? ""
            self.staffNameStr = taskDetail?.staffName ?? ""
            self.siteListingStr = taskDetail?.siteName ?? ""
            //self.arrSelectedServiceIds = taskDetail?.serviceIDs ?? []
            self.slectedDepartMentName = taskDetail?.departmentName ?? ""
            self.priorityField = taskDetail?.priority ?? ""
            if taskDetail?.departmentID?.count ?? 0 > 0 {
                self.departmentCode = taskDetail?.departmentID ?? ""
            }
            self.tasktitleStr = taskDetail?.taskTitle ?? ""
            if selectedTask == .bankIn {
                self.amountDateFrom2 = taskDetail?.bankInToDate ?? ""
                self.amontDateFrom1 = taskDetail?.bankInFromDate ?? ""
                self.amountStr = taskDetail?.amount ?? ""
                self.isSelectedImage = true
            }
            
            getSiteListing()
            tableView.reloadData()
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }else {
            lblnavTitle.text = "Task Creation"
            selectedTaskType = taskOptionArr[0]
            callRemoveAllVal()
        }
    }
    
    //create protocol function
    func selectedStaffMember(staffMember: StaffMember) {
        //let indexPath = IndexPath(item: 0, section: 3)
        staffCodeStr = staffMember.staffCode ?? ""
        staffNameStr = staffMember.fullName
        siteCodeStr = staffMember.siteCode ?? ""
        siteListingStr = ""
        siteListingId = ""
        tableView.reloadData()
        getSiteListing()
        //tableView.reloadRows(at: [indexPath], with: .top)
    }
    //SelectedService Type
    func didSelectedResult(_ arrSelectedIds: [String], selectedDepartment: DepartmentList?) {
        self.arrSelectedServiceIds = arrSelectedIds
        self.selectedDepartmentType = selectedDepartment
        self.departmentCode = selectedDepartment?.departmentCode ?? ""
        self.slectedDepartMentName = selectedDepartment?.departmentName ?? ""
        tableView.reloadData()
    }
    //GetDepartment List
    func getTaskType(){
        let url = "\(base)\(Apis.getTaskType)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                self.arrTaskTypes.removeAll()
                result.forEach({ (dict) in
                    self.arrTaskTypes.append(TaskType(fromDictionary: dict))
                    self.tableView.reloadData()
                })
            }
        }
    }
    //Get Site Listing
    func getSiteListing(){
        var siteCode = ""
        var staffCode = ""
        
        guard let selectedTaskType = selectedTaskType else {
            singleButtonAlertWith(message: .custom("Please select task type."))
            return
        }
        switch selectedTaskType {
        case .outletRequest:
            siteCode = profile.siteCode ?? ""
            staffCode = profile.staffCode ?? ""
        default :
            siteCode = siteCodeStr
            staffCode = staffCodeStr
        }
        let actionURL = "\(base)\(Apis.staffSiteListing)\(siteCode)&staffCode=\(staffCode)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            self.arrOptionList.removeAll()
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrOptionList.append(SiteListingOption(fromDictionary: dict))
                })
            }
        }
    }
    
    func checkCommonSiteListing(){
        if let loadedCart = UserDefaults.standard.array(forKey: "mySiteListing") as? [[String: Any]] {
            for item in loadedCart{
                for data in self.siteListingArr{
                    if let siteCode = item["siteCode"] as? String{
                        if let itemCode = data["itemCode"] as? String{
                            if itemCode == siteCode{
                                mySiteListing.append(data)
                            }
                        }
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func textFieldEditingDidChange(_ sender: UITextField){
        if selectedTaskType! == .outletRequest {
            print(sender.text!)
            if sender.text != "" {
                getTaskDetail(txtString:sender.text!)
            }
        }
    }
    var arrCustomerList = [CustomerList]()
    func getTaskDetail(txtString:String){
        let url = "\(base)\(Apis.getCustomerList)\(profile.siteCode ?? "")&customerName=\(txtString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "\(base)\(Apis.getCustomerList)\(profile.siteCode ?? "")&customerName=\(txtString)"
        WebService.shared.getDataFrom(api: url) { (sucess , response, msg) in
            print(response)
            if let result = response["result"] as? [[String: Any]] {
                self.arrCustomerList.removeAll()
                result.forEach({ (dict) in
                    self.arrCustomerList.append(CustomerList(fromDictionary: dict))
                })
            }
            if self.arrCustomerList.count > 0{
                self.getCustomerTblView.isHidden = false
            }else{
                self.customernameStr = ""
                self.singleButtonAlertWith(message: .custom("No customer found."))
                self.getCustomerTblView.isHidden = true
                self.tableView.reloadData()
            }
            self.getCustomerTblHeight.constant = CGFloat(44 * self.arrCustomerList.count)
            self.getCustomerTblView.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 501{
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryNameCell", for: indexPath) as! categoryNameCell
            cell.selectionStyle = .none
            //cell.customerNameLbl.text = taskDetail?.customerName ?? ""
            let customerModel = arrCustomerList[indexPath.row]
            cell.customerNameLbl.text = customerModel.customerName ?? ""
            let customerCode = customerModel.customerCode ?? ""
            tasktitleStr = customerCode
            customerNamCode = customerCode
            customernameStr = customerModel.customerName ?? ""
            return cell
        } else {
            guard let taskCreateSection = TaskCreationSection(rawValue: indexPath.section)  else {
                return UITableViewCell()
            }
            switch taskCreateSection {
            case .taskType:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskTypeCell", for: indexPath) as! taskTypeCell
                cell.selectionStyle = .none
                cell.taskTypeTF.tag = indexPath.section
                cell.taskTypeTF.inputAccessoryView = toolBar
                cell.taskTypeTF.inputView = picker
                if let selectedTaskType = selectedTaskType {
                    cell.taskTypeTF.text = selectedTaskType.value
                } else {
                    cell.taskTypeTF.text = ""
                }
                cell.taskTypeTF.placeholder = "Task Type"
                cell.taskTypeTF.delegate = self
                cell.taskTypeTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                return cell
                
            case .customerName:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.text = customernameStr
                cell.infoTF.keyboardType = .default
                if let selectedTaskType = self.selectedTaskType, selectedTaskType == .outletRequest {
                    cell.infoTF.placeholder = "Customer Profile"
                } else {
                    cell.infoTF.placeholder = "Customer Name"
                }
                cell.infoTF.tag = indexPath.section
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
                
            case .taskTitle:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.text = tasktitleStr
                cell.infoTF.placeholder = "Task Title"
                cell.infoTF.tag = indexPath.section
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
                
            case .taskDescription:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.text = taskDesc
                cell.infoTF.keyboardType = .default
                cell.infoTF.placeholder = "Task Description"
                cell.infoTF.tag = indexPath.section
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
                
            case .date:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                if let selectedtaskType = self.selectedTaskType, selectedtaskType == .appointment {
                    cell.infoTF.placeholder = "Appointment Date"
                } else {
                    cell.infoTF.placeholder = "Date"
                }
                cell.infoTF.tag = indexPath.section
                cell.infoTF.text = selectAppointmentDateStr
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
                
            case .startTime:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.placeholder = "Start Time"
                cell.infoTF.text = startTime
                cell.infoTF.tag = indexPath.section
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
            case .endDate:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.placeholder = "End Date"
                cell.infoTF.tag = indexPath.section
                cell.infoTF.text = selectEndDateStr
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
                
            case .endTime:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.placeholder = "End Time"
                cell.infoTF.tag = indexPath.section
                cell.infoTF.delegate = self
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.text = endTime
                
                return cell
            case .amount:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.infoTF.placeholder = "Amount"
                cell.infoTF.text = amountStr
                cell.infoTF.keyboardType = .numberPad
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                cell.infoTF.tag = indexPath.section
                return cell
            case .department:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskDeptCell", for: indexPath) as! taskDeptCell
                cell.deptTF.text = slectedDepartMentName ?? ""
                if let selectedTaskType = selectedTaskType {
                    if selectedTaskType == .walkIn || selectedTaskType == .appointment {
                        cell.deptTF.placeholder = "Service"
                    } else {
                        cell.deptTF.placeholder = "Department"
                    }
                }
                cell.selectionStyle = .none
                cell.deptTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                return cell
                
            case .staffName:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskStaffNameCell", for: indexPath) as! taskStaffNameCell
                cell.selectionStyle = .none
                cell.taskStaffNameTF.tag = indexPath.section
                cell.taskStaffNameTF.text = staffNameStr
                cell.taskStaffNameTF.inputAccessoryView = toolBar
                cell.taskStaffNameTF.inputView = picker
                cell.taskStaffNameTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                return cell
            case .requestTherapist:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskRequestCell", for: indexPath) as! taskRequestCell
                cell.selectionStyle = .none
                cell.requestTherapySelectBtn.isSelected = isThearpyRequestSelected
                cell.requestTherapySelectBtn.setImage(isThearpyRequestSelected ? UIImage(named: "selcted") : UIImage(named: "unselected"), for: .normal)
                return cell
            case .prority:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskPriorityCell", for: indexPath) as! taskPriorityCell
                cell.selectionStyle = .none
                cell.taskPriorityTF.tag = indexPath.section
                cell.taskPriorityTF.placeholder = "Priority"
                cell.taskPriorityTF.inputAccessoryView = toolBar
                cell.taskPriorityTF.inputView = picker
                cell.taskPriorityTF.text = priorityField
                cell.taskPriorityTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.taskPriorityTF.delegate = self
                return cell
            case .bankInAmountFromDate:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BankAmountCell", for: indexPath) as! BankAmountCell
                cell.selectionStyle = .none
                cell.bankAmountTF.tag = indexPath.section
                cell.bankAmountTF.text = amontDateFrom1
                cell.bankAmountTF.placeholder = "Bank In Amount From Date"
                cell.bankAmountTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.bankAmountTF.delegate = self
                return cell
            case .bankInAmountToDate:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BankAmountCell", for: indexPath) as! BankAmountCell
                cell.selectionStyle = .none
                cell.bankAmountTF.tag = indexPath.section
                cell.bankAmountTF.text = amountDateFrom2
                cell.bankAmountTF.placeholder = "Bank In Amount To Date"
                cell.bankAmountTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.bankAmountTF.delegate = self
                return cell
            case .currentOutlet:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskInfoCell", for: indexPath) as! taskInfoCell
                cell.selectionStyle = .none
                cell.infoTF.tag = indexPath.section
                cell.infoTF.placeholder = "Current Outlet"
                cell.infoTF.text = currentOutletName
                cell.infoTF.isUserInteractionEnabled = false
                cell.infoTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.infoTF.delegate = self
                return cell
            case .changeOutlet:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskPriorityCell", for: indexPath) as! taskPriorityCell
                cell.selectionStyle = .none
                cell.taskPriorityTF.tag = indexPath.section
                cell.taskPriorityTF.placeholder = "Change to which Outlet"
                cell.taskPriorityTF.inputAccessoryView = toolBar
                cell.taskPriorityTF.inputView = picker
                cell.taskPriorityTF.text = changedOutletName
                cell.taskPriorityTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                cell.taskPriorityTF.delegate = self
                return cell
            case .branchName:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SiteListingCell", for: indexPath) as! SiteListingCell
                cell.selectionStyle = .none
                cell.siteListingTF.tag = indexPath.section
                // cell.siteListingTF.setIcon(UIImage(named:"down")!)
                cell.siteListingTF.inputAccessoryView = toolBar
                cell.siteListingTF.inputView = picker
                cell.siteListingTF.text = siteListingStr
                cell.siteListingTF.placeholderColor = #colorLiteral(red: 0.482, green: 0.478, blue: 0.29, alpha: 1)
                return cell
            case .selectFiles:
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectFilesCell", for: indexPath) as! selectFilesCell
                if self.isComeFromUpdate {
                    cell.profileImgView.image = nil
                    cell.profileImgView.sd_setImage(with: URL(string: taskDetail?.manager.managerAttachment ?? ""), placeholderImage: UIImage(named: "profile"))
                    cell.profileImgView.contentMode = .scaleToFill
                    pic = cell.profileImgView.image
                }
                cell.selectionStyle = .none
                return cell
            case .submitButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitBtnCell", for: indexPath) as! SubmitBtnCell
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 501{
            return arrCustomerList.count
        }else{
            guard let taskCreateSection = TaskCreationSection(rawValue: section)  else {
                return 0
            }
            guard let selectedTaskType =  self.selectedTaskType else {
                return 1
            }
            switch selectedTaskType {
            case .appointment:
                switch taskCreateSection {
                case .taskType, .customerName, .taskDescription, .date, .startTime,.endDate, .endTime, .department, .staffName, .requestTherapist, .prority, .branchName, .submitButton:
                    return 1
                default:
                    return 0
                }
            case .bankIn:
                switch taskCreateSection {
                case .taskType, .date, .amount, .staffName, .prority, .bankInAmountFromDate, .bankInAmountToDate, .branchName, .selectFiles, .submitButton:
                    return 1
                default:
                    return 0
                }
            case .external:
                switch taskCreateSection {
                case .taskType, .taskTitle, .taskDescription, .date, .startTime,.endDate, .endTime, .staffName, .prority, .branchName, .selectFiles, .submitButton:
                    return 1
                default:
                    return 0
                }
            case .outletRequest:
                switch taskCreateSection {
                case .taskType, .customerName, .currentOutlet, .changeOutlet, .submitButton:
                    return 1
                default:
                    return 0
                }
            case .walkIn:
                switch taskCreateSection {
                case .taskType, .customerName, .taskDescription, .date, .startTime, .endDate, .endTime, .department, .staffName, .requestTherapist, .prority, .branchName, .submitButton:
                    return 1
                default:
                    return 0
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 501{
            return 44
        }else{
            guard let taskCreateSection = TaskCreationSection(rawValue: indexPath.section)  else {
                return 0
            }
            switch taskCreateSection {
            case .selectFiles:
                return 150
            default:
                return 70
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 501{
            return 1
        }else{
            return TaskCreationSection.count.rawValue
        }
    }
    var customerNamCode:String = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 501{
            let customerList = self.arrCustomerList[indexPath.row]
            let customerCode = customerList.customerCode ?? ""
            customerNamCode = customerCode
            customernameStr = customerList.customerName ?? ""
            self.getCustomerTblView.isHidden = true
            if let selectedTaskType =  self.selectedTaskType, selectedTaskType == .outletRequest {
                getCustomerCurrentOutlet(customerCode: customerNamCode)
            }
            self.tableView.reloadData()
        }else{
            if indexPath.section == TaskCreationSection.staffName.rawValue{
                let vc = StaffMemberVC.instantiateFrom(storyboard: .siteManagement)
                vc.siteListing = [["siteCode": profile.siteCode ?? ""]]
                //                vc.siteListing = Utility.shared.getSiteListingParameter( siteListing: profile.siteListing)
                vc.staffmemberDelegate = self
                vc.screenOpenedFrom = .taskCreation
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.section == TaskCreationSection.department.rawValue {
                let vc = DepartmentVC.instantiateFrom(storyboard: .taskManagement)
                vc.selectedDepartment = selectedDepartmentType
                vc.selectedDepartMentCode = self.departmentCode
                delegateSelectedServiceType = self
                vc.arrSelectedServiceTypeIds = arrSelectedServiceIds
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.section == TaskCreationSection.requestTherapist.rawValue {
                isThearpyRequestSelected = !isThearpyRequestSelected
                tableView.reloadData()
            }
        }
    }
    @objc func donePicker(){
        guard let taskCreateSection = TaskCreationSection(rawValue: activeFieldTag)  else {
            return
        }
        let currentRow = picker.selectedRow(inComponent: 0)
        switch taskCreateSection {
        case .prority:
            if  currentRow < priorityArr.count   {
                priorityField = priorityArr[currentRow]
            }
            
        case .changeOutlet:
            if currentRow < arrOptionList.count   {
                let value = self.arrOptionList[currentRow]
                changedOutletCode = value.itemCode ?? ""
                changedOutletName = value.itemDesc ?? ""
            }
        case .branchName:
            if currentRow < arrOptionList.count   {
                let value = self.arrOptionList[currentRow]
                siteListingId = value.itemCode ?? ""
                siteListingStr = value.itemDesc ?? ""
                getBankInAmount()
                
            }
        default:
            break
        }
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    //Create PickerView
    // SET PICKER
    func setPicker(){
        picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
    }
    
    
    @IBAction func actionRequestTherpy(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @IBAction func valueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd MMM yyyy"
        if activeFieldTag == TaskCreationSection.date.rawValue {
            datePicker.minimumDate = Date()
            let strDate = dateFormatter.string(from: datePicker.date)
            selectAppointmentDateStr = strDate
            self.startDateAndTime = selectAppointmentDateStr + startDateStr
        }else if activeFieldTag == TaskCreationSection.endDate.rawValue {
            datePicker.minimumDate = Date()
            let strDate = dateFormatter.string(from: datePicker.date)
            selectEndDateStr = strDate
            endDateAndTime = "\(selectEndDateStr) \(endDateStr)"
        }else if activeFieldTag == TaskCreationSection.bankInAmountFromDate.rawValue{
            datePicker.minimumDate = Date()
            let strDate = dateFormatter.string(from: datePicker.date)
            amontDateFrom1 = strDate
            getBankInAmount()
        }else if activeFieldTag == TaskCreationSection.bankInAmountToDate.rawValue{
            datePicker.minimumDate = Date()
            let strDate = dateFormatter.string(from: datePicker.date)
            amountDateFrom2 = strDate
            getBankInAmount()
        }else if activeFieldTag == TaskCreationSection.startTime.rawValue{
            startDateAndTime = ""
            dateFormatter.dateFormat =  "HH:mm"
            let strDate = dateFormatter.string(from: datePicker.date)
            startDateStr =  strDate
            self.startDateAndTime = selectAppointmentDateStr + startDateStr
            dateFormatter.dateFormat =  "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            startTime = dateFormatter.string(from: datePicker.date)
        }else if activeFieldTag == TaskCreationSection.endTime.rawValue{
            endDateAndTime = ""
            dateFormatter.dateFormat =  "HH:mm"
            let strDate = dateFormatter.string(from: datePicker.date)
            endDateStr =  strDate
            endDateAndTime = "\(selectEndDateStr) \(endDateStr)"
            dateFormatter.dateFormat =  "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            endTime = dateFormatter.string(from: datePicker.date)
        }
        tableView.reloadData()
    }
    
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let taskCreateSection = TaskCreationSection(rawValue: activeFieldTag)  else {
            return 0
        }
        switch taskCreateSection {
        case .taskType:
            return taskOptionArr.count
        case .prority:
            return priorityArr.count
        case .changeOutlet:
            return  self.arrOptionList.count
        case .branchName:
            return self.arrOptionList.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let taskCreateSection = TaskCreationSection(rawValue: activeFieldTag)  else {
            return ""
        }
        switch taskCreateSection {
        case .taskType:
            return taskOptionArr[row].value
        case .prority:
            return priorityArr[row]
        case .changeOutlet:
            return  self.arrOptionList[row].itemDesc ?? ""
        case .branchName:
            return self.arrOptionList[row].itemDesc ?? ""
        default:
            return ""
        }
        return ""
    }
    func callRemoveAllVal(){
        amontDateFrom1 = ""
        amountDateFrom2 = ""
        customernameStr = ""
        tasktitleStr = ""
        taskDesc = ""
        amountStr = ""
        selectAppointmentDateStr = ""
        selectEndDateStr = ""
        //taskName = ""
        startDateStr = ""
        endDateStr = ""
        //  GlobalBaseClass.departmentServiceId = ""
        staffCodeStr = ""
        requestTherapy = ""
        priorityField = ""
        siteListingStr = ""
        siteListingId = ""
        staffNameStr = ""
        changedOutletName = ""
        changedOutletCode = ""
        requestTherapy = "false"
        startTime = ""
        endTime = ""
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        guard let taskCreateSection = TaskCreationSection(rawValue: activeFieldTag)  else {
            return
        }
        switch taskCreateSection {
        case .taskType:
            selectedTaskType = taskOptionArr[row]
            callRemoveAllVal()
        case .prority:
            priorityField = priorityArr[row]
        case .changeOutlet:
            changedOutletCode = self.arrOptionList[row].itemCode ?? ""
            changedOutletName = self.arrOptionList[row].itemDesc ?? ""
        case .branchName:
            let selectdeCtg = arrOptionList[row]
            siteListingId = selectdeCtg.itemCode ?? ""
            siteListingStr = selectdeCtg.itemDesc ?? ""
            getBankInAmount()
        default:
            break
        }
        self.view.endEditing(true)
        tableView.reloadData()
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        datePicker.maximumDate = nil
        //        datePicker.minimumDate = nil
        datePickerSuperView.isHidden = true
        activeFieldTag = textField.tag
        if textField.tag == TaskCreationSection.date.rawValue ||  textField.tag == TaskCreationSection.bankInAmountFromDate.rawValue || textField.tag == TaskCreationSection.bankInAmountToDate.rawValue || textField.tag == TaskCreationSection.endDate.rawValue{
            datePickerSuperView.isHidden = false
            datePicker.datePickerMode = .date
            datePicker.reloadInputViews()
            return false
        } else if textField.tag == TaskCreationSection.startTime.rawValue {
            datePickerSuperView.isHidden = false
            datePicker.datePickerMode = .time
            //            datePicker.minimumDate = Date()
            //            datePicker.maximumDate = nil
            datePicker.reloadInputViews()
            return false
        }else if textField.tag == TaskCreationSection.endTime.rawValue {
            datePickerSuperView.isHidden = false
            datePicker.datePickerMode = .time
            //            datePicker.maximumDate = Date()
            //            datePicker.minimumDate = nil
            datePicker.reloadInputViews()
            return false
        }
        return true
    }
    @IBAction func datePickerValuChange(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func DonePickerBtnTap(_ sender: Any) {
        guard let taskCreateSection = TaskCreationSection(rawValue: activeFieldTag)  else {
            return
        }
        let dateFormatter = DateFormatter()
        switch taskCreateSection {
        case .date:
            datePicker.minimumDate = Date()
            dateFormatter.dateFormat =  "dd MMM yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
            selectAppointmentDateStr = strDate
            startDateAndTime = "\(selectAppointmentDateStr) \(startDateStr)"
        case .endDate:
            datePicker.minimumDate = Date()
            dateFormatter.dateFormat =  "dd MMM yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
            selectEndDateStr = strDate
            endDateAndTime = "\(selectEndDateStr) \(endDateStr)"
        case .startTime:
            dateFormatter.dateFormat =  "HH:mm"
            let strDate = dateFormatter.string(from: datePicker.date)
            startDateStr =  strDate
            startDateAndTime = "\(selectAppointmentDateStr) \(startDateStr)"
            dateFormatter.dateFormat =  "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            startTime = dateFormatter.string(from: datePicker.date)
        case .endTime:
            dateFormatter.dateFormat =  "HH:mm"
            let endDate = dateFormatter.string(from: datePicker.date)
            endDateStr =  endDate
            endDateAndTime = "\(selectEndDateStr) \(endDateStr)"
            dateFormatter.dateFormat =  "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            endTime = dateFormatter.string(from: datePicker.date)
            endDateStr =  endDate
            
            //            dateFormatter.dateFormat =  "h:mm a"
            //            dateFormatter.amSymbol = "AM"
            //            dateFormatter.pmSymbol = "PM"
        //            endTime = dateFormatter.string(from: datePicker.date)
        case .bankInAmountFromDate:
            datePicker.minimumDate = Date()
            dateFormatter.dateFormat =  "dd MMM yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
            amontDateFrom1 = strDate
            getBankInAmount()
        case .bankInAmountToDate:
            datePicker.minimumDate = Date()
            dateFormatter.dateFormat =  "dd MMM yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
            amountDateFrom2 = strDate
            getBankInAmount()
        default:
            break
        }
        datePickerSuperView.isHidden = true
        tableView.reloadData()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var taskURL:String = ""
    @IBAction func submitBtnTap(_ sender: Any) {
        if isComeFromUpdate == true{
            taskURL = "updateTask"
        }else{
            taskURL = "createTask"
        }
        submitTaskCreation()
    }
    
    func callUpdateTaskDetail(){
    }
    //Get Site Listing
    func submitTaskCreation(){
        setValidationAccToType()
    }
    
    //Call Task Creation APi
    func calltaskCreationApi(param: [String:Any]){
        let url = "\(base)\(taskURL)"
        WebService.shared.postDataFor(api: url, parameters: param as [String : AnyObject]) { (sucess, response, msg) in
            var taskID = String()
            if let result = response["result"] as? [[String: Any]] {
                if let dict = result.first {
                    if let taskId = dict["taskID"] as? String {
                        taskID = taskId
                    }
                }
            }else {
                taskID = self.taskIdStr
            }
            if let selectedTaskType = self.selectedTaskType{
                switch selectedTaskType{
                case .appointment, .walkIn:
                    self.goToBackVC()
                case .bankIn, .external:
                    self.updateTaskPicture(taskID: taskID)
                default:
                    self.goToBackVC()
                }
            }else {
                self.goToBackVC()
            }
            
        }
    }
    func setValidationAccToType(){
        guard let selectedTaskType = selectedTaskType else {
            singleButtonAlertWith(message: .custom("Please select task type."))
            return
        }
        switch selectedTaskType {
        case .appointment, .walkIn:
            break
        case .bankIn:
            break
        case .external:
            break
        case .outletRequest:
            break
        }
        if selectedTaskType == .appointment || selectedTaskType == .walkIn {
            if customernameStr == ""{
                singleButtonAlertWith(message: .custom("Please enter customer name."))
            }else if taskDesc == ""{
                singleButtonAlertWith(message: .custom("Please enter task description."))
            }else if  selectAppointmentDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select appoinment date."))
            }else if  startDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select start time."))
            }else if selectEndDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select end date."))
            }else if  endDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select end time."))
            }else if Utility.shared.comparisonBetweenTwoDates(startTime: startDateAndTime, endTime: endDateAndTime) {
                singleButtonAlertWith(message: .custom("End time should be greater then Start time."))
            }else if  GlobalBaseClass.departmentId == ""{
                singleButtonAlertWith(message: .custom("Please enter Department/Service"))
            }else if  staffNameStr == ""{
                singleButtonAlertWith(message: .custom("Please select staff name"))
            }else if  priorityField == ""{
                singleButtonAlertWith(message: .custom("Please set priority"))
            }else if siteListingStr == ""{
                singleButtonAlertWith(message: .custom("Please choose Site Listing"))
            }else{
                if isComeFromUpdate == true{
                    let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: selectAppointmentDateStr)
                    let endDateAndTime  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy HH:mm", toFormat: "yyyy/MM/dd HH:mm:ss", dateString: self.endDateAndTime)
                    let parameter = [
                        "userID":profile.userID ?? "",
                        "taskType":selectedTaskType.value,
                        "taskDescription":self.taskDesc,
                        "customerName":self.customernameStr,
                        "appointmentDate":startDate,
                        "appointmentStartTime":startDateStr,
                        "appointmentEndTime":endDateAndTime,
                        "serviceIDs": GlobalBaseClass.departmentServiceId,
                        "departmentID": GlobalBaseClass.departmentId,
                        "staffID": "",
                        "isRequestTherapist":isThearpyRequestSelected,
                        "priority":self.priorityField,
                        "siteCode": siteListingId,
                        "staffCode": staffCodeStr,
                        "taskID":self.taskIdStr
                        ] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }else{
                    let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: selectAppointmentDateStr)
                    let endDateAndTime  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy HH:mm", toFormat: "yyyy/MM/dd HH:mm:ss", dateString: self.endDateAndTime)
                    let parameter = [
                        "userID":profile.userID ?? "",
                        "taskType":selectedTaskType.value,
                        "taskDescription":self.taskDesc,
                        "customerName":self.customernameStr,
                        "appointmentDate":startDate,
                        "appointmentStartTime":startDateStr,
                        // "appointmentEndTime":endDateStr,
                        "appointmentEndTime":endDateAndTime,
                        "serviceIDs": GlobalBaseClass.departmentServiceId,
                        "departmentID": GlobalBaseClass.departmentId,
                        "staffID": "",
                        "isRequestTherapist":isThearpyRequestSelected,
                        "priority":self.priorityField,
                        "siteCode": siteListingId,
                        "staffCode": staffCodeStr
                        ] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }
            }
        } else if selectedTaskType == .bankIn {
            if selectAppointmentDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select date."))
            }else if staffNameStr == ""{
                singleButtonAlertWith(message: .custom("Please select staff name"))
            }else if priorityField == ""{
                singleButtonAlertWith(message: .custom("Please set priority"))
            }else if amontDateFrom1 == "" {
                singleButtonAlertWith(message: .custom("Please select bank in amount from date ."))
            }else if amountDateFrom2 == "" {
                singleButtonAlertWith(message: .custom("Please select bank in amount to date ."))
            }else if self.amountStr == "" {
                singleButtonAlertWith(message: .custom("Please enter amount."))
            }else if self.siteListingStr == "" {
                singleButtonAlertWith(message: .custom("Please select site listing."))
            }else if !isSelectedImage {
                singleButtonAlertWith(message: .custom("Please select file."))
            }else{
                if isComeFromUpdate == true{
                    let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: selectAppointmentDateStr)
                    let bankInToDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: amountDateFrom2)
                    let bankInFromDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: amontDateFrom1)
                    
                    let parameter = [
                        "userID": profile.userID ?? "",
                        "appointmentDate": startDate,
                        "staffID": "",
                        "siteCode": siteListingId,
                        "taskType": selectedTaskType.value,
                        "bankInFromDate": bankInFromDate,
                        "bankInToDate": bankInToDate,
                        "amount":self.amountStr,
                        "priority": self.priorityField,
                        "staffCode": staffCodeStr,
                        "taskID":self.taskIdStr
                        ] as [String : Any]
                    
                    //                    let parameter = ["siteCode": profile.siteCode ?? "","userID":profile.userID ?? "","taskType":selectedTaskType.rawValue,"Appointment":"","taskTitle":self.tasktitleStr,"taskDescription":self.taskDesc,"customerCode":"","customerName":self.customernameStr,"appointmentDate":selectAppointmentDateStr,"appointmentStartTime":startDateStr,"appointmentEndTime":endDateStr,"amount":self.amountStr,"departmentID":GlobalBaseClass.departmentServiceId,"staffID": self.staffCodeStr, "serviceIDs":"","isRequestTherapist":requestTherapy,"profilePic":"","priority":self.priorityField,"changedOutlet":"","taskID":self.taskIdStr] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }else{
                    let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: selectAppointmentDateStr)
                    let bankInToDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: amountDateFrom2)
                    let bankInFromDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: amontDateFrom1)
                    
                    let parameter = [
                        "userID": profile.userID ?? "",
                        "appointmentDate": startDate,
                        "staffID": "",
                        "siteCode": siteListingId,
                        "taskType": selectedTaskType.value,
                        "bankInFromDate": bankInFromDate,
                        "bankInToDate": bankInToDate,
                        "amount":self.amountStr,
                        "priority": self.priorityField,
                        "staffCode": staffCodeStr
                        ] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }
            }
        }else if selectedTaskType == .external{
            if tasktitleStr == ""{
                singleButtonAlertWith(message: .custom("Please enter task title."))
            }else if  taskDesc == ""{
                singleButtonAlertWith(message: .custom("Please enter Task description."))
            }else if selectAppointmentDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select date."))
            }else if  startDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select start time."))
            }else if selectEndDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select end date."))
            }else if  endDateStr == ""{
                singleButtonAlertWith(message: .custom("Please select end time."))
            }else if Utility.shared.comparisonBetweenTwoDates(startTime: startDateAndTime, endTime: endDateAndTime) {
                singleButtonAlertWith(message: .custom("End date should be greater then Start date."))
            }else if  staffNameStr == ""{
                singleButtonAlertWith(message: .custom("Please enter staff name."))
            }else if  priorityField == ""{
                singleButtonAlertWith(message: .custom("Please set priority."))
            }else if siteListingStr == ""{
                singleButtonAlertWith(message: .custom("Please select site lisitng."))
            }else if !isSelectedImage {
                singleButtonAlertWith(message: .custom("Please select file."))
            }else{
                let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: selectAppointmentDateStr)
                let endDateAndTimeNew  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy HH:mm", toFormat: "yyyy/MM/dd HH:mm:ss", dateString: self.endDateAndTime)
                
                if isComeFromUpdate == true {
                    //                    let parameter = ["taskID":self.taskIdStr,
                    //                                     "siteCode": profile.siteCode ?? "",
                    //                                     "customerName": customernameStr,
                    //                                     "userID":profile.userID ?? "",
                    //                                     "customerCode": customerNamCode,
                    //                                     "taskType":selectedTaskType.value,
                    //                                     "taskTitle":self.tasktitleStr,
                    //                                     "taskDescription":self.taskDesc,
                    //                                     "appointmentDate":startDate,
                    //                                     "appointmentEndTime":endDateStr,
                    //                                     "appointmentStartTime":startDateStr,
                    //                                     "departmentID":GlobalBaseClass.departmentServiceId,
                    //                                     "serviceIDs":"",
                    //                                     "staffID": "",
                    //                                     "priority":self.priorityField,
                    //                                     "amount":self.amountStr,
                    //                                     "changedOutlet":"",
                    //                                     "currentOutler": "",]
                    
                    let parameter = [
                        "taskID":self.taskIdStr,
                        "siteCode": siteListingId,
                        "userID": profile.userID ?? "",
                        "taskType":selectedTaskType.value,
                        "taskTitle": self.tasktitleStr,
                        "taskDescription": self.taskDesc,
                        "appointmentDate": startDate,
                        "appointmentStartTime":startDateStr,
                        "appointmentEndTime":endDateAndTimeNew,
                        "staffID": "",
                        "priority":self.priorityField,
                        "staffCode": staffCodeStr
                        ] as [String : Any]
                    
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }else {
                    //                let startDate  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "yyyy/MM/dd", dateString: selectAppointmentDateStr)
                    
                    let parameter = [
                        "siteCode": siteListingId,
                        "userID": profile.userID ?? "",
                        "taskType":selectedTaskType.value,
                        "taskTitle": self.tasktitleStr,
                        "taskDescription": self.taskDesc,
                        "appointmentDate": startDate,
                        "appointmentStartTime":startDateStr,
                        //  "appointmentEndTime":endDateStr,
                        "appointmentEndTime":endDateAndTimeNew,
                        "staffID": "",
                        "priority":self.priorityField,
                        "staffCode": staffCodeStr
                        ] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }
            }
        }else if selectedTaskType == .outletRequest {
            if customernameStr == ""{
                singleButtonAlertWith(message: .custom("Please enter customer name."))
            }else if changedOutletName == ""{
                singleButtonAlertWith(message: .custom("Please select site lisitng."))
            }else {
                if isComeFromUpdate == true{
                    let parameter = [
                        "staffID": "",
                        "siteCode": siteListingId,
                        "userID": profile.userID ?? "",
                        "taskType": selectedTaskType.value,
                        "customerName": self.customernameStr,
                        "customerCode": customerNamCode,
                        "currentOutlet": currentOutletCode,
                        "changedOutlet": changedOutletCode,
                        "staffCode": staffCodeStr,
                        "taskID":self.taskIdStr
                        ] as [String : Any]
                    //                    let parameter = ["siteCode": profile.siteCode ?? "","userID":profile.userID ?? "","taskType":selectedTaskType.rawValue,"Appointment":"","taskTitle":"","taskDescription":"","customerCode":"","customerName":self.customernameStr,"appointmentDate":"","appointmentStartTime":"","appointmentEndTime":"","amount":"","departmentID":GlobalBaseClass.departmentServiceId,"staffID": "", "serviceIDs":"","isRequestTherapist":"","profilePic":"","priority":"","changedOutlet":self.priorityField,"currentOutlet":customerNamCode,"taskID":self.taskIdStr] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }else{
                    let parameter = [
                        "staffID": "",
                        "siteCode": siteListingId,
                        "userID": profile.userID ?? "",
                        "taskType": selectedTaskType.value,
                        "customerName": self.customernameStr,
                        "customerCode": customerNamCode,
                        "currentOutlet": currentOutletCode,
                        "changedOutlet": changedOutletCode
                        //   "staffCode": staffCodeStr
                        ] as [String : Any]
                    print(parameter)
                    self.calltaskCreationApi(param: parameter)
                }
            }
        }
    }
    //MARK:- Get Bank In Amount
    func getBankInAmount() {
        guard let selectedTaskType = selectedTaskType else {
            return
        }
        let amontDateFrom1  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: self.amontDateFrom1)
        let amountDateFrom2  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd MMM yyyy", toFormat: "yyyy/MM/dd", dateString: self.amountDateFrom2)
        if selectedTaskType != .bankIn || siteListingId == "" || amontDateFrom1 == "" || amountDateFrom2 == "" {
            return
        }
        let url = "\(baseDashboard)\(Apis.getBankInAmount)?siteCode=\(siteListingId)&fromDate=\(amontDateFrom1)&toDate=\(amountDateFrom2)"
        //        let param = ["siteCode" : siteListingId,
        //                    "fromDate": amontDateFrom1,
        //                    "toDate": amountDateFrom2
        //                    ]
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                if let dict = result.first {
                    if let amount = dict["amount"] as? NSNumber {
                        self.amountStr = "\(amount.doubleValue)"
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    private func getCustomerCurrentOutlet(customerCode: String) {
        let url = "\(base)\(Apis.getCustomerSite)\(profile.siteCode ?? "")&customerCode=\(customerNamCode)"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    if let temp = dict["siteCode"] as? String? {
                        self.currentOutletCode = temp ?? ""
                    }
                    if let temp = dict["siteName"] as? String? {
                        self.currentOutletName = temp ?? ""
                    }
                })
                self.tableView.reloadData()
                self.getSiteListing()
            }
        }
    }
    @IBAction func cameraBtnTap(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        initiateImagePicker(imagePicker, isVideo: false, editingAllowed: true)
    }
    //MARK:- Methods to upload image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        picker.allowsEditing = true
        if let pickedImage = info[.originalImage] as? UIImage {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: TaskCreationSection.selectFiles.rawValue)) as! selectFilesCell
            picker.allowsEditing = true
            picker.delegate = self
            cell.profileImgView.contentMode = .scaleToFill
            imageData = pickedImage.jpegData(compressionQuality: 0.6) ?? Data()
            cell.profileImgView.image = pickedImage
            pic = cell.profileImgView.image
            self.isSelectedImage = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePicker(_ imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateTaskPicture(taskID: String){
        if pic != nil{
            //{"siteCode":"HS04","taskID":"25","userID":""}
            let imgdict = ["file": pic.jpegData(compressionQuality: 0.6) ?? Data()]
            let josnDict = Utility.shared.json(from: ["siteCode": profile.siteCode ?? "" , "userID": profile.userID ?? "","taskID": taskID])
            let params = ["jsonKey":josnDict ?? ""] as [String : AnyObject]
            let url = "\(base)\(Apis.updateTaskPicture)"
            WebService.shared.uploadMediaToServer(api: url, imgMedia: imgdict , parameters: params) { (sucess, result, msg) in
                self.goToBackVC()
            }
        }
    }
    func goToBackVC(){
        self.navigationController?.popViewController(animated: true)
    }
}
extension TaskCreationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let taskCreateSection = TaskCreationSection(rawValue: activeFieldTag)  else {
            return
        }
        switch taskCreateSection {
        case .branchName:
            if staffNameStr == "" {
                IQKeyboardManager.shared.enableAutoToolbar = false
                singleButtonAlertWith(message: .custom("Please select staff name"))
            }else {
                IQKeyboardManager.shared.enableAutoToolbar = true
            }
            break
        case .startTime:
            datePicker.minimumDate = Date()
            datePicker.maximumDate = nil
        case .endTime:
            datePicker.maximumDate = Date()
            datePicker.minimumDate = nil
        default:
            datePicker.maximumDate = nil
            datePicker.minimumDate = nil
            break
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag ==  TaskCreationSection.customerName.rawValue {
            customernameStr = ""
            if !(textField.text?.trimmingCharacters(in: .whitespaces) == "") {
                customernameStr =  (textField.text?.trimmingCharacters(in: .whitespaces))!
                getTaskDetail(txtString: customernameStr)
            }
        }else if textField.tag == TaskCreationSection.taskTitle.rawValue {
            tasktitleStr = textField.text!
        }else if textField.tag == TaskCreationSection.taskDescription.rawValue {
            taskDesc = textField.text!
        }else if textField.tag == TaskCreationSection.amount.rawValue {
            amountStr = textField.text!
        }
        tableView.reloadData()
    }
}
