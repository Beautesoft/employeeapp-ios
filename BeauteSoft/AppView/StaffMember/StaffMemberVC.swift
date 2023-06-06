//
//  StaffMemberVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/7/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//Create protocol class to send data back
protocol StaffMemberDelegate: class {
    func selectedStaffMember(staffMember: StaffMember)
}

class StaffMemberCell:UITableViewCell{
    
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var imgStaffMember: UIImageView!
    
}

class StaffMemberVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var vwLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var searchStaffMember: UISearchBar!
  
    var isComeFromEmployee:Bool = false
    var arrStaffMember = [StaffMember]()
    var siteListing = [[String: Any]]()
    var staffName = ""
    var staffMemberArr:[[String:Any]] = []
    var staffMemberDict:[String:Any] = [:]
    
    weak var staffmemberDelegate: StaffMemberDelegate?
    var filtering = false
    var filteredArr = [StaffMember]()
    var isActive = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 130
        searchStaffMember.delegate = self
        vwLeadingConst.constant = 410
    }
    
    enum ScreenOpenedFrom: Int {
        case siteManagement
        case taskCreation
        case workSchedule
        case employeeManagement
        case taskDetail
    }
    
    var screenOpenedFrom: ScreenOpenedFrom = .siteManagement
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.backgroundColor = .clear
        getStaffMemberList()
        if screenOpenedFrom == .employeeManagement {
           addBtn.isHidden = false
        }else {
           addBtn.isHidden = true
        }
    }
    func getStaffMemberList(){
        let parameter = ["SiteListing": siteListing,"staffName": staffName,"siteCode": profile.siteCode ?? "", "isActive": isActive] as [String : AnyObject]
        print(parameter)
        WebService.shared.postDataFor(api: base + Apis.getStaffMember, parameters: parameter) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                self.arrStaffMember.removeAll()
                result.forEach({ (dict) in
                    self.arrStaffMember.append(StaffMember(fromDictionary: dict))
                    self.tableView.reloadData()
                })
            }
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionHideSearchView(_ sender: Any) {
        vwLeadingConst.constant = 410
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        self.filtering = false
        self.filteredArr = []
        vwLeadingConst.constant = 0
        searchStaffMember.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffMemberCell") as! StaffMemberCell
        cell.selectionStyle = .none
        let staffMember = self.filtering ? self.filteredArr[indexPath.row] : arrStaffMember[indexPath.row]
        cell.displayNameLbl.text =  staffMember.fullName
        cell.imgStaffMember.sd_setImage(with: URL(string: staffMember.profilePic ?? ""), placeholderImage: UIImage(named: "member_icon"))
        cell.locationNameLbl.text  = "location: " + (staffMember.siteName ?? "")
        cell.phoneNumLbl.text  = "Phone number: " + (staffMember.contact ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtering ? self.filteredArr.count : arrStaffMember.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch screenOpenedFrom {
        case .siteManagement:
            let staffMemberModel = self.filtering ? self.filteredArr[indexPath.row] : arrStaffMember[indexPath.row]
            let vc = StaffMemberProfileVC.instantiateFrom(storyboard: .siteManagement)
            vc.comesFromEmployeeManagement = false
            vc.staffMember = staffMemberModel
            self.navigationController?.pushViewController(vc, animated: true)
        case .taskCreation:
            let getStaffMember = self.filtering ? self.filteredArr[indexPath.row] : arrStaffMember[indexPath.row]
            staffmemberDelegate?.selectedStaffMember(staffMember: getStaffMember)
            self.navigationController?.popViewController(animated: true)
        case .workSchedule:
             let staffMember = self.filtering ? self.filteredArr[indexPath.row] : arrStaffMember[indexPath.row]
             let vc = WorkScheduleVC.instantiateFrom(storyboard: .workSchedule)
             vc.staffMember = staffMember
             self.navigationController?.pushViewController(vc, animated: true)
            break
        case .employeeManagement:
            let staffMemberModel = self.filtering ? self.filteredArr[indexPath.row] : arrStaffMember[indexPath.row]
            let vc = StaffMemberProfileVC.instantiateFrom(storyboard: .siteManagement)
            vc.comesFromEmployeeManagement = true
            vc.staffMember = staffMemberModel
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .taskDetail:
            let getStaffMember = self.filtering ? self.filteredArr[indexPath.row] : arrStaffMember[indexPath.row]
            staffmemberDelegate?.selectedStaffMember(staffMember: getStaffMember)
            self.navigationController?.popViewController(animated: true)
            break
        }
    }
    
    //Button Action
    @IBAction func addBtnTap(_ sender: Any) {
        let vc = UpdateEmployeeVC.instantiateFrom(storyboard: .employee)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension StaffMemberVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            print(searchText)
            self.filteredArr = self.arrStaffMember.filter { ($0.fullName.localizedCaseInsensitiveContains(searchText))
            }
            print(self.filteredArr)
            self.filtering = true
        }
        else {
            self.filtering = false
            self.filteredArr = []
        }
        self.tableView.reloadData()
    }
}
