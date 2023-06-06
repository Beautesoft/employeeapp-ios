//
//  StaffMemberProfileVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/10/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class StaffMemberProfileVC: UIViewController, SiteListingOptionDelegate {
 
    
    @IBOutlet weak var vwTaskList: UIView!
    @IBOutlet weak var vwSiteListing: UIView!
    @IBOutlet weak var taskListBtn: UIButton!
    @IBOutlet weak var taskListArroBtn: UIButton!
    @IBOutlet weak var taskListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet weak var btnDeactive: UIButton!
    
    var staffMember: StaffMember?
    var screenOpenFromEmployeeManagement = Bool()
    var comesFromEmployeeManagement = false
    var isEditHide:Bool = false
    var memberDetailDict:[String:Any] = [:]
    var staffName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesFromEmployeeManagement {
           editBtn.isHidden = false
           vwTaskList.isHidden = false
            
        }else {
            //Yoonus
            //Showing task and edit from site
           //editBtn.isHidden = true
           //vwTaskList.isHidden = true
            editBtn.isHidden = false
            vwTaskList.isHidden = false
        }
        displayData()
    }
    
    private func displayData() {
        locationNameLbl.text = staffMember?.siteName ?? ""
        phoneNumLbl.text = staffMember?.contact ?? ""
        userNameLbl.text = staffMember?.firstName ?? ""
        profileImgView.sd_setImage(with: URL(string: staffMember?.profilePic ?? ""), placeholderImage: UIImage(named: "member_icon"))
        if staffMember?.isActive ?? true {
            btnDeactive.setTitle("DEACTIVATE", for: .normal)
        } else {
            btnDeactive.setTitle("ACTIVATE", for: .normal)
        }

        
    }

    func didSelectedSites(with result: [SiteListingOption]) {
        let arrListinOption = result.map{["siteCode": ($0).itemCode ?? ""]}
        self.updateEmployeeSiteListing(arrListinOption: arrListinOption)
    }
    
    @IBAction func taskListBtnTap(_ sender: Any) {
        let vc = TaskListVC.instantiateFrom(storyboard: .taskManagement)
        vc.screenOpenFromEmployeeManagement = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        
    }
    
    @IBAction func actionSelectedMember(_ sender: Any) {
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnTap(_ sender: Any) {
      let vc = UpdateEmployeeVC.instantiateFrom(storyboard: .employee)
      vc.staffMember = staffMember
      vc.isComesFromUpdate = true
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionDeactive(_ sender: Any) {
        if staffMember?.isActive ?? true {
            deactivateAccount ()
        } else {
            
        }
    }
    
    @IBAction func siteListingBtnTap(_ sender: Any) {
        let vc =  SiteListingOptionsVC.instantiateFrom(storyboard: .siteManagement)
        vc.staffMember = staffMember
        vc.screenOpenedFrom = .staffMemberProfile
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func deactivateAccount () {
        let params = ["staffCode": staffMember?.staffCode ?? "","siteCode": staffMember?.siteCode ?? ""]  as [String : AnyObject]
        let url = "\(base)\(Apis.deactivateStaffMember)"
        WebService.shared.postDataFor(api: url, parameters: params) { (sucess,response,msg) in
            self.singleButtonAlertWith(message: .deactivatedMember, button: .ok, completionOnButton: {
                self.navigationController?.popToRootViewController(animated: true)
            } )
        }
    }
    private func updateEmployeeSiteListing(arrListinOption: [[String:Any]]) {
        let parameter = ["staffCode": staffMember?.staffCode ?? "","siteCode": staffMember?.siteCode ?? "","SiteListing":arrListinOption] as [String : AnyObject]
        let url = "\(base)\(Apis.updateSiteListingOption)"
        
        WebService.shared.postDataFor(api: url, parameters: parameter) {  (sucess, response, msg) in
            self.singleButtonAlertWith(message: .custom("Transfered successfully"),completionOnButton: {
                self.getStaffMemberList(siteListing: arrListinOption)
            })
        }
    }
    
    func getStaffMemberList(siteListing: [[String:Any]]){
        let parameter = ["SiteListing": siteListing,"staffName": staffMember?.firstName ?? "","siteCode": profile.siteCode ?? ""] as [String : AnyObject]
        print(parameter)
        WebService.shared.postDataFor(api: base + Apis.getStaffMember, parameters: parameter) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                    if let dict = result.first {
                        self.staffMember = nil
                       self.staffMember = StaffMember(fromDictionary: dict)
                    }
            }
        }
    }
}
