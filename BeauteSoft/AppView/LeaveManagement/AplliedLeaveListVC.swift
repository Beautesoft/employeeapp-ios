//
//  AplliedLeaveVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 31/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class AplliedLeaveListVC: UIViewController {

    @IBOutlet weak var tableVwLeaveList: UITableView!
    var arrLeaves = [AppliedLeave]()
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override func viewWillAppear(_ animated: Bool) {
        getList()
    }
    //Get Leave list
    private func getList() {
        let url = "\(base)\(Apis.getAppliedLeaveList)"
        let parameter = ["siteCode": profile.siteCode ?? ""] as [String : AnyObject]
        WebService.shared.postDataFor(api: url, parameters: parameter) { (success, response, message) in
            if success {
                if let result = response["result"] as? [[String:Any]]{
                    result.forEach({ (dictionary) in
                        self.arrLeaves.append(AppliedLeave(fromDictionary: dictionary))
                    })
                    DispatchQueue.main.async {
                        self.tableVwLeaveList.reloadData()
                    }
                }
            }
        }
    }
    //MARK: button action
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionCeateLeave(_ sender: Any) {
        let vc = ApplyLeaveVC.instantiateFrom(storyboard: .leaveManagement)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension AplliedLeaveListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeaves.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.AppliedLeavedTVC.rawValue, for: indexPath) as! AppliedLeavedTVC
        let model = arrLeaves[indexPath.row]
        cell.lblName.text = model.message ?? ""
        cell.lblAppliedDate.text = "Apply Date:   \(model.startDate ?? "")-\(model.endDate ?? "")"
        cell.lblStatus.text = "Status:     \(model.status ?? "")"
        cell.lblStatus.setTextColor(color: .red, string: model.status ?? "")
        cell.imgEmployee.sd_setImage(with: URL(string: model.profPic ?? "") , placeholderImage: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leaveModel = arrLeaves[indexPath.row]
        let vc = LeaveDetailVC.instantiateFrom(storyboard: .leaveManagement)
        vc.leaveDetailModel = leaveModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
    }
}
