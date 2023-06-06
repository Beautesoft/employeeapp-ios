//
//  StaffMemberTaskDetailVC.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 10/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit
     // "You Accepted this request. Do you want to make it confirm?"
     //  btn Confirm,Reject
     //You have confirmed this Task Already. Do you complete this request ?
     // btn Complete

class StaffMemberTaskDetailVC: UIViewController, TaskAcceptedDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskId = ""
    var taskDetail: TaskDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        getTaskDetail()
    }
    
    //MARK: - button action
    @IBAction func actionAccept(_ sender: Any) {
        guard let status = TaskStatus(rawValue: (taskDetail?.status ?? "")) else {
            return
        }
        switch status {
        case .open:
            let taskAcceptVC = TaskAcceptVC.instantiateFrom(storyboard: .taskManagement)
            taskAcceptVC.taskId = taskId
            taskAcceptVC.delegate = self
            self.present(taskAcceptVC, animated: true, completion: nil)
        case .accepted:
             self.updateTaskStatus(TaskStatus.confirmed.intValue)
        case .confirmed:
           self.updateTaskStatus(TaskStatus.completed.intValue)
        case .pending:
            self.updateTaskStatus(TaskStatus.confirmed.intValue)
        default:
            return
        }
      
    }
    func didAcceptTask() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionStaffAttachment(_ sender: UIButton) {
        let vc = SeeAttachmentVC.instantiateFrom(storyboard: .taskManagement)
        vc.url = taskDetail?.attachment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionManagerAttachment(_ sender: Any) {
        if taskDetail?.manager.managerAttachment != "" || taskDetail?.manager.managerComment != ""{
            let vc = SeeAttachmentVC.instantiateFrom(storyboard: .taskManagement)
            vc.url = taskDetail?.manager.managerAttachment ?? ""
            vc.taskDetail = taskDetail
            vc.screenComesFromManager = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            singleButtonAlertWith(message: .custom("No attachment found."))
        }
    }
    
    @IBAction func actionSeeAttachment(_ sender: UIButton) {
        if taskDetail?.attachment != "" || taskDetail?.queries != ""{
            let vc = SeeAttachmentVC.instantiateFrom(storyboard: .taskManagement)
            vc.url = taskDetail?.attachment ?? ""
            vc.taskDetail = taskDetail
            vc.screenComesFromManager = false
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            singleButtonAlertWith(message: .custom("No attachment found."))
        }
    }

    @IBAction func actionDecline(_ sender: Any) {
        guard let status = TaskStatus(rawValue: (taskDetail?.status ?? "")) else {
            return
        }
        switch status {
        case .open:
            self.alertWith(message: .custom("Are you sure you want to decline task?"), actions: (.cancel,nil),(.ok,{
                self.updateTaskStatus(TaskStatus.cancelled.intValue)
                
            }))
        case .accepted:
            self.updateTaskStatus(TaskStatus.pending.intValue)
        default:
            return
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    private func updateTaskStatus (_ status: Int) {
        let url = "\(base)\(Apis.updateTaskStatus)"
        let parameter = [
            "taskID": taskId,
            "status": status,
            "siteCode": profile.siteCode ?? "",
            "remarks": "",
            "queries": ""

            ] as [String: AnyObject]
        WebService.shared.postDataFor(api: url, parameters: parameter as [String : AnyObject]) { (sucess, response, msg) in
            var message = "Task status updated successfully"
            if let result = response["result"] as? String {
                message = result
            }
            self.singleButtonAlertWith(message: .custom(message), completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }
    }
    
    /// Fetch task Details
    func getTaskDetail(){
        let url = "\(base)\(Apis.getTaskDetail)\(taskId)&siteCode=\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]], let dict = result.first {
                self.taskDetail = TaskDetail(fromDictionary: dict)
                self.tableView.reloadData()
            }
        }
    }
    
    private func getConfirmationMessages() -> (message: String, rejectTitle: String, acceptTitle: String) {
        guard let status = TaskStatus(rawValue: (taskDetail?.status ?? "")) else {
            return (message: "", rejectTitle: "", acceptTitle: "")
        }
        switch status {
        case .open:
            return (message: "You did'nt accept the request. Do you want to accept it?", rejectTitle: "Reject", acceptTitle: "Accept")
        case .accepted:
            return (message: "You accepted this request. Do you want to make it confirmed?", rejectTitle: "Reject", acceptTitle: "Confirm")
        case .confirmed:
            return (message: "You have already confirmed this task. Do you want to complete this request?", rejectTitle: "Reject", acceptTitle: "Complete")
        case .pending:
            return (message: "You have put this task to pending. Do you want to make it confirmed?", rejectTitle: "", acceptTitle: "Confirm")
        default:
            return (message: "", rejectTitle: "", acceptTitle: "")
        }
    }

}
extension StaffMemberTaskDetailVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskDetailSection = StaffMemberTaskDetailSections(rawValue: section), let taskDetail = self.taskDetail else {
            return 0
        }
        switch taskDetailSection {
        case .taskInfo:
            return 1
        case .status:
            return 1
        case .staffInfo:
            return 1
        case .taskActions:
            if taskDetail.status == TaskStatus.cancelled.rawValue || taskDetail.status == TaskStatus.completed.rawValue {
                return 0
            }
            return 1
        case .taskCompleted:
            if taskDetail.status == TaskStatus.completed.rawValue {
                return 1
            }
            return 0
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return StaffMemberTaskDetailSections.count.rawValue
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskDetailSection = StaffMemberTaskDetailSections(rawValue: indexPath.section), let taskDetail = self.taskDetail else {
            return UITableViewCell()
        }
        switch taskDetailSection {
        case .taskInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerNameCell",for: indexPath) as! CustomerNameCell
            cell.selectionStyle = .none
            cell.titlelbl.text = "Dept: \(taskDetail.departmentName ?? "")"
//            if taskDetail.taskTitle == "" {
//                cell.vwTitlelabel.isHidden = true
//            }else {
//                cell.titlelbl.text = taskDetail.taskTitle ?? ""
//            }
            cell.lblCustomerName.text = "Customer Name: \(taskDetail.customerName ?? "")"
            cell.lblCustomerName.setFont(font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold), to: taskDetail.customerName ?? "")
            cell.lblDesc.text = taskDetail.taskDescription ?? ""
            let appointmentDate = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy", dateString: taskDetail.appointmentDate ?? "")
            
            let appointmentStartTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "h:mm a", dateString: taskDetail.appointmentStartTime ?? "")
            
            let appointmentEndTime = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd h:mm:ss.SSS", toFormat: "dd MMM yyyy  h:mm a", dateString: taskDetail.appointmentEndTime ?? "")

            cell.lblDate.text = "\(appointmentDate)  \(appointmentStartTime) - \(appointmentEndTime)"
            cell.lblTime.text = taskDetail.taskType ?? ""
            return cell
        case .status:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell",for: indexPath) as! StatusCell
            cell.selectionStyle = .none
            cell.statusLbl.text = taskDetail.status
            return cell
        case .staffInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReAssignCell") as! ReAssignCell
            cell.selectionStyle = .none
            cell.userNameLbl.text = taskDetail.userID
            cell.locationNamLbl.text = taskDetail.manager.branchName
            cell.imgStaff.sd_setImage(with: URL(string: taskDetail.manager.profilePic ?? ""), placeholderImage: UIImage(named: "profile"))

            return cell
        case .taskActions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachementCell") as! AttachementCell
            cell.selectionStyle = .none
            let confirmationMessage = getConfirmationMessages()
            cell.btnAccept.isHidden = confirmationMessage.acceptTitle == ""
            cell.btnDecline.isHidden = confirmationMessage.rejectTitle == ""
            cell.btnAccept.setTitle(confirmationMessage.acceptTitle, for: .normal)
            cell.btnDecline.setTitle(confirmationMessage.rejectTitle, for: .normal)
            cell.lblConfirmationMessage.text =  confirmationMessage.message
            return cell
        case .taskCompleted:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell",for: indexPath) as! StatusCell
            cell.selectionStyle = .none
            cell.lblStatusDisplay.text = "Completed task"
            cell.statusLbl.isHidden = true
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
