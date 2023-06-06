//
//  LeaveStatusDetailVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 09/06/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class LeaveStatusDetailVC: UIViewController {
    
    @IBOutlet weak var imgLeave: UIImageView!
    @IBOutlet weak var lblStaffName: UILabel!
    @IBOutlet weak var lblBranchName: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblLeaveApply: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblStaffReason: UILabel!
    @IBOutlet weak var txtVwComment: UITextView!
    var leaveStatus: LeaveStatus?
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnApproved: UIButton!
    
    private enum leaveState: String {
        case approved = "Approved"
        case rejected = "Reject"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtVwComment.delegate = self
        txtVwComment.text = "Write your subject"
        txtVwComment.textColor = UIColor.lightGray
        showData ()
    }
    private func showData () {
        lblStaffName.text = "Staff Name: \(leaveStatus?.staffName ?? "")"
        lblStaffName.setFont(font: .boldSystemFont(ofSize: 17), to: "Staff Name")
       
        lblBranchName.text = "Branch Name: \(leaveStatus?.branchName ?? "")"
        lblBranchName.setFont(font: .boldSystemFont(ofSize: 17), to: "Branch Name")
        
        lblLeaveType.text = "Leave Type: \(leaveStatus?.leaveType ?? "")"
        lblLeaveType.setFont(font: .boldSystemFont(ofSize: 17), to: "Leave Type")
        
        lblLeaveApply.text = "Leave Apply: \(leaveStatus?.noOfDays ?? "") Days"
        lblLeaveApply.setFont(font: .boldSystemFont(ofSize: 17), to: "Leave Apply")
        
        lblDate.text = "Date: \(leaveStatus?.startDate ?? "")-\(leaveStatus?.endDate ?? "")"
        lblDate.setFont(font: .boldSystemFont(ofSize: 17), to: "Date")
       
        lblDays.text = "Days: \(leaveStatus?.noOfDays ?? "")"
        lblDays.setFont(font: .boldSystemFont(ofSize: 17), to: "Days")
        
        lblStaffReason.text = leaveStatus?.staffComments ?? ""
        imgLeave.sd_setImage(with: URL(string: leaveStatus?.attachedFile ?? "") , placeholderImage: UIImage(named: "member_icon"))
        
        btnApproved.isHidden = false
        btnReject.isHidden = false
        
        if leaveStatus?.status == leaveState.approved.rawValue {
            btnApproved.isHidden = true
        }else if leaveStatus?.status == leaveState.rejected.rawValue {
            btnReject.isHidden = true
        }
    }
    //MARK: button action
    @IBAction func actionBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionApproved(_ sender: Any) {
        if txtVwComment.text == "Write your subject" || txtVwComment.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.singleButtonAlertWith(message: .custom("Please add some comment"), button: .ok)
        }else {
            leaveApprovedRejected (status: "\(leaveState.approved.rawValue)")
        }
    }
    @IBAction func actionReject(_ sender: Any) {
        if txtVwComment.text == "Write your subject" || txtVwComment.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.singleButtonAlertWith(message: .custom("Please add some comment"), button: .ok)
        }else {
            leaveApprovedRejected (status: "\(leaveState.rejected.rawValue)")
        }
    }
    //MARK: api for leave approve or reject
    private func leaveApprovedRejected (status: String) {
        let param = ["siteCode": profile.siteCode ?? "","status": status,"managerID": profile.userID ?? "","applicationID": leaveStatus?.applicationID ?? ""] as [String : AnyObject] as [String : AnyObject]
        WebService.shared.postDataFor(api: base + Apis.updateLeaveStatus, parameters: param) { (success, response, message) in
            if success {
                if let result = response["result"] as? String {
                        self.singleButtonAlertWith(message: .custom(result),completionOnButton: {
                         self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
}
extension LeaveStatusDetailVC: UITextViewDelegate {
    //UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your subject"
            textView.textColor = UIColor.lightGray
        }else{
            txtVwComment.text = textView.text
        }
    }
    
}
