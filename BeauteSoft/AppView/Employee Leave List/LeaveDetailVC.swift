//
//  LeaveDetailVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/19/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class LeaveDetailVC: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var managerCommentsLbl: UILabel!
    @IBOutlet var stillCommentsLbl: UILabel!
    @IBOutlet var daysLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var leaveApplyLbl: UILabel!
    @IBOutlet var leaveTypeLbl: UILabel!
    @IBOutlet var branchLbl: UILabel!
    @IBOutlet var staffNameLbl: UILabel!
    
    var leaveDetailDict:[String:Any] = [:]
    var leaveDetailModel: AppliedLeave?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.sd_setImage(with: URL(string: leaveDetailModel?.profPic ?? ""), placeholderImage: UIImage(named: "profile"))
       
        staffNameLbl.text = "Staff Name:    \(leaveDetailModel?.staffName ?? "")"
        staffNameLbl.setFont(font: .boldSystemFont(ofSize: 17), to: "Staff Name")
      
        branchLbl.text = "Branch:    \(leaveDetailModel?.branchName ?? "")"
        branchLbl.setFont(font: .boldSystemFont(ofSize: 17), to: "Branch")
       
        leaveTypeLbl.text = "Leave Type:    \(leaveDetailModel?.leaveType ?? "")"
        leaveTypeLbl.setFont(font: .boldSystemFont(ofSize: 17), to: "Leave Type")
        
        leaveApplyLbl.text = "Leave Apply \(leaveDetailModel?.leaveApply ?? "")"
        leaveApplyLbl.setFont(font: .boldSystemFont(ofSize: 17), to: "Leave Apply")
        
        dateLbl.text = "Date:    \(leaveDetailModel?.startDate ?? "")-\(leaveDetailModel?.endDate ?? "")"
        dateLbl.setFont(font: .boldSystemFont(ofSize: 17), to: "Date")
        
        daysLbl.text = "Days    \(leaveDetailModel?.noOfDays ?? "")"
        daysLbl.setFont(font: .boldSystemFont(ofSize: 17), to: "Days")
        
        stillCommentsLbl.text = leaveDetailModel?.staffComments ?? ""
        managerCommentsLbl.text = leaveDetailModel?.managerComments ?? ""
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
