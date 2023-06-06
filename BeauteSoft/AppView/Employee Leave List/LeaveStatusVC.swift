//
//  LeaveStatusVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/18/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit


class leaveStatusCell:UITableViewCell{
    
}
class LeaveStatusVC: UIViewController {

    @IBOutlet var tblView: UITableView!
    @IBOutlet var rejectedBtn: UIButton!
    @IBOutlet var approvedBtn: UIButton!
    @IBOutlet var newReceivedBtn: UIButton!
    var arrLeaveStatus = [LeaveStatus]()

    var leaveCategory: LeaveCategory = .newReceived
    var leaveState: LeaveState = .Pending
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if leaveCategory == .newReceived {
            getLeaveListTypes(leaveState: leaveState)
        }
    }
    //MARK: button action
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func newReceivedBtnTap(_ sender: Any) {
        newReceivedBtn.setBackgroundImage(UIImage(named: "newReceived_selected"), for: .normal)
        rejectedBtn.setBackgroundImage(UIImage(named: "newRejected_unselected"), for: .normal)
        approvedBtn.backgroundColor = UIColor.clear
        leaveCategory = .newReceived
        getLeaveListTypes(leaveState: .Pending)
    }
    @IBAction func approvedBtnTap(_ sender: Any) {
        leaveCategory = .approved
        newReceivedBtn.setBackgroundImage(UIImage(named: "newReceived_unselected"), for: .normal)
        rejectedBtn.setBackgroundImage(UIImage(named: "newRejected_unselected"), for: .normal)
        approvedBtn.backgroundColor = UIColor(red: 223/256.0, green:  208/256.0, blue:  136/256.0, alpha: 1.0)
        getLeaveListTypes(leaveState: .Approved)
    }
    @IBAction func rejectedBtnTap(_ sender: Any) {
        leaveCategory = .rejected
        newReceivedBtn.setBackgroundImage(UIImage(named: "newReceived_unselected"), for: .normal)
        rejectedBtn.setBackgroundImage(UIImage(named: "rejected_status"), for: .normal)
        approvedBtn.backgroundColor = UIColor.clear
        getLeaveListTypes(leaveState: .Reject)
    }
    
    //Get Leaves types
    private func getLeaveListTypes(leaveState: LeaveState){
        self.arrLeaveStatus.removeAll()
        var parameter = [String: AnyObject]()
        if leaveCategory == .approved{
          parameter = ["siteCode": profile.siteCode ?? "","status": "Approved"] as [String : AnyObject]
        }else if leaveCategory == .newReceived{
          parameter = ["siteCode": profile.siteCode ?? "","status": "Apply"] as [String : AnyObject]
        }else if leaveCategory == .rejected {
          parameter = ["siteCode": profile.siteCode ?? "","status": "Reject"] as [String : AnyObject]
        }
        
        WebService.shared.postDataFor(api: base + Apis.getAppliedLeaveList, parameters: parameter) { (success, response, message) in
            if success {
                if let result = response["result"] as? [[String:Any]]{
                    result.forEach({ (dictionary) in
                        let leaveStatus = LeaveStatus(fromDictionary: dictionary)
                        self.arrLeaveStatus.append(leaveStatus)
                    })
                }
            }
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
}
extension LeaveStatusVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeaveStatus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.LeaveStatusTVC.rawValue) as! LeaveStatusTVC
        cell.selectionStyle = .none
        let leaveStatus = arrLeaveStatus[indexPath.row]
        cell.imgLeave.sd_setImage(with: URL(string: leaveStatus.profPic ?? "") , placeholderImage: UIImage(named: "member_icon"))
        cell.lblName.text = leaveStatus.staffName ?? ""
        cell.lblLeaveType.text = leaveStatus.leaveType ?? ""
        cell.lblDate.text = "\(leaveStatus.startDate ?? "")-\(leaveStatus.endDate ?? "")"
       // cell.lblDate.setFont(font: .boldSystemFont(ofSize: 17), to: "Date")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if leaveCategory == .newReceived{
            let model = arrLeaveStatus[indexPath.row]
            let vc = LeaveStatusDetailVC.instantiateFrom(storyboard: .leaveManagement)
            vc.leaveStatus = model
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
