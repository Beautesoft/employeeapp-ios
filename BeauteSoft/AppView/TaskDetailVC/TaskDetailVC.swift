//
//  TaskDetailVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/30/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class ReAssignCell:UITableViewCell{
    
    @IBOutlet weak var lblReassignTo: UILabel!
    @IBOutlet weak var imgStaff: UIImageView!
    @IBOutlet var locationNamLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
}
class CustomerNameCell:UITableViewCell{
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet var titlelbl: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var vwTitlelabel: UIView!
}
class StatusCell:UITableViewCell{
    @IBOutlet weak var lblStatusDisplay: UILabel!
    @IBOutlet var statusLbl: UILabel!
}
class AttachementCell:UITableViewCell{
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var setTextView: UITextView!
    @IBOutlet weak var lblConfirmationMessage: UILabel!
    @IBOutlet weak var txtViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var lblManagerCommnet: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
}

class TaskDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,StaffMemberDelegate {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var lblCustomerName: UILabel!
    var taskDetailArrDict:[[String:Any]] = []
    var taskListDict:[String:Any] = [:]
    var taskId:String = ""
    var taskListModel: TaskList?
    var arrTaskDetail = [TaskDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTaskDetail()
    }
    //create protocol function
    func selectedStaffMember(staffMember: StaffMember) {
        callReassignTaskApi(staffCodeStr: staffMember.staffCode)
    }
    
    
    private func submitTaskComment(comment: String) {
        let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy/MM/dd")
        let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy/MM/dd HH:mm")
        let parameter = ["siteCode": profile.siteCode ?? "",
                         "taskID": taskListModel?.taskId ?? "",
                         "Comments":  comment,
                         "Date":  getCurrentDate ,
                         "Time":  getCurrentTime ,
                         "userID": profile.userID ?? ""
            ] as [String : AnyObject]
        let url = "\(base)\(Apis.createTaskComments)"
        WebService.shared.postDataFor(api: url, parameters: parameter) { (sucess, response, msg) in
            self.singleButtonAlertWith(message: .custom("Task Comments is created successfully") , completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    //Call Task Creation APi
    func getTaskDetail(){
        let url = "\(base)\(Apis.getTaskDetail)\(taskListModel?.taskId ?? "")&siteCode=\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                self.arrTaskDetail.removeAll()
                result.forEach({ (dict) in
                    self.arrTaskDetail.append(TaskDetail(fromDictionary: dict))
                })
                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func deleteTaskBtnTap(_ sender: Any) {
        let resend: AlertButtonWithAction = (.ok, {
            self.deleteTaskApi()
        })
        let cancel: AlertButtonWithAction = (.cancel, nil)
        self.alertWith(message: .custom("Are you sure you want to delete?"), actions: resend,cancel)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AttachementCell
        if cell.setTextView.text == "Write a comment" || cell.setTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.singleButtonAlertWith(message: .custom("Please enter your comment"), button: .ok)
        }else {
            submitTaskComment(comment: cell.setTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    @IBAction func actionStaffAttachment(_ sender: UIButton) {
        let model = arrTaskDetail[sender.tag]
        if model.attachment != "" || model.queries != ""{
            let vc = SeeAttachmentVC.instantiateFrom(storyboard: .taskManagement)
            vc.url = model.attachment ?? ""
            vc.taskDetail = model
            vc.screenComesFromManager = false
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            singleButtonAlertWith(message: .custom("No attachment found."))
        }
    }
    @IBAction func actionSeeAttachment(_ sender: UIButton) {
        let model = arrTaskDetail[sender.tag]
        if model.manager.managerAttachment != "" || model.manager.managerComment != ""{
            let vc = SeeAttachmentVC.instantiateFrom(storyboard: .taskManagement)
            vc.url = model.manager.managerAttachment ?? ""
            vc.taskDetail = model
            vc.screenComesFromManager = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            singleButtonAlertWith(message: .custom("No attachment found."))
        }
    }
    func deleteTaskApi(){
        let url = "\(base)\(Apis.deletetask)?taskID=\(taskListModel?.taskId ?? "")"
        let parameter = ["taskID": taskListModel?.taskId ?? ""] as [String : AnyObject]
        WebService.shared.postDataFor(api: url, parameters: parameter) { (sucess, response, msg) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func goToBackVC(){
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskDetail.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerNameCell",for: indexPath) as! CustomerNameCell
            cell.selectionStyle = .none
            let model = arrTaskDetail[indexPath.row]
            if model.taskTitle == "" {
                cell.vwTitlelabel.isHidden = true
            }else {
                cell.titlelbl.text = model.taskTitle ?? ""
            }
            cell.lblCustomerName.text = "Customer Name: \(model.customerName ?? "")"
            cell.lblCustomerName.setFont(font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold), to: model.customerName ?? "")
            cell.lblDesc.text = model.taskDescription ?? ""
            let appointmentDate = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy", dateString: model.appointmentDate ?? "")
            
            let appointmentStartTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "h:mm a", dateString: model.appointmentStartTime ?? "")
            let appointmentEndTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "dd MMM yyyy  h:mm a", dateString: model.appointmentEndTime ?? "")
            cell.lblDate.text = "\(appointmentDate) \(appointmentStartTime) - \(appointmentEndTime)"
            cell.lblTime.text = model.taskType ?? ""
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell",for: indexPath) as! StatusCell
            cell.selectionStyle = .none
            let model = arrTaskDetail[indexPath.row]
            cell.statusLbl.text = model.status
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReAssignCell") as! ReAssignCell
            cell.selectionStyle = .none
            let model = arrTaskDetail[indexPath.row]
            cell.userNameLbl.text = model.staffName ?? ""
            cell.locationNamLbl.text = model.siteName
            cell.lblReassignTo.text = model.status == "Completed" ? "Staff" : "Re-assign To"
            cell.imgStaff.sd_setImage(with: URL(string: model.profilePic ?? ""), placeholderImage: UIImage(named: "profile"))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachementCell") as! AttachementCell
            let model = arrTaskDetail[indexPath.row]
            cell.setTextView.text = "Write a comment"
            cell.setTextView.delegate = self
            cell.selectionStyle = .none
            cell.setTextView.layer.borderWidth = 1.0
            cell.setTextView.layer.cornerRadius = 10.0
            cell.setTextView.layer.borderColor = UIColor.lightGray.cgColor
            if model.status == "Completed" {
                cell.txtViewHeightConst.constant = 0
                cell.lblManagerCommnet.text = ""
                cell.commentImage.isHidden = true
                cell.btnSubmit.isHidden = true
            }else {
                cell.txtViewHeightConst.constant = 115
                cell.lblManagerCommnet.text = "Manager Comments"
                cell.commentImage.isHidden = false
                cell.btnSubmit.isHidden = false
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 215
        }else if indexPath.section == 1{
            return 44
        }else if indexPath.section == 2{
            return 140
        }else{
            return 315
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let model = arrTaskDetail[indexPath.row]
            if model.status != "Completed" {
                let vc = StaffMemberVC.instantiateFrom(storyboard: .siteManagement)
                vc.siteListing = [["siteCode": profile.siteCode ?? ""]]
                vc.screenOpenedFrom = .taskDetail
                vc.staffmemberDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editBtnTap(_ sender: UIButton) {
        let model = arrTaskDetail[sender.tag]
        let vc = TaskCreationVC.instantiateFrom(storyboard: .taskManagement)
        vc.taskImage = taskListModel?.taskImage ?? ""
        vc.isComeFromUpdate = true
        vc.taskDetail = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //Call Re Assign Task
    func callReassignTaskApi(staffCodeStr: String){
        let taskURL = "updateTask"
        let parameter = [
            "userID":profile.userID ?? "",
            "siteCode": profile.siteCode ?? "",
            "staffCode": staffCodeStr,
            "taskID": taskListModel?.taskId ?? ""
            ] as [String : Any]
        let url = "\(base)\(taskURL)"
        WebService.shared.postDataFor(api: url, parameters: parameter as [String : AnyObject]) { (sucess, response, msg) in
            self.getTaskDetail()
        }
    }
}
extension TaskDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AttachementCell
        if textView == cell.setTextView{
            if textView.text == "Write a comment"{
                textView.text = ""
                textView.textColor = UIColor.darkText
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AttachementCell
        if textView == cell.setTextView{
            if textView.text == "" {
                textView.text = "Write a comment"
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
