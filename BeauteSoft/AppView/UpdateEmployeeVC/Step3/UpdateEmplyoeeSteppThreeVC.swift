//
//  UpdateEmplyoeeSteppThreeVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/12/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class UpdateEmplyoeeSteppThreeVC: UIViewController {
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    
    var parameterDict:[String:Any] = [:]
    var staffMember: StaffMember?
    var isComesFromEdit = false
    
    enum AllowedOptionStepThree : String {
        case discount = "Entitlement to give discount"
        case userActive = "User is currently active"
        case attendMakeUp = "Attendance Make Up"
        case deleteArtical = "Delete Matser Articles"
        case transactions = "Void Transactions"
        case foc = "FOC"
        case settlement = "Day end settlement"
        case sendEmail = "Send Email"
    }
    var arrAllowedOption: [(AllowedOptionStepThree,Bool)] = [(.discount,false), (.userActive,false),(.attendMakeUp, false), (.deleteArtical,false), (.transactions,false), (.foc,false), (.settlement,false), (.sendEmail,false)]
    var staffCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComesFromEdit {
          getStaffMemberDetail()
        }else {
           tblView.reloadData()
        }
    }
    private func getStaffMemberDetail() {
        var siteListing = [[String: Any]]()
        var parameterDict :[String:Any] = [:]
        siteListing = [["siteCode": profile.siteListing[0].siteCode ?? ""]]
         let selectedSiteListing =  Utility.shared.getSiteListingParameter(siteListing: profile.siteListing)
        parameterDict.updateValue(selectedSiteListing, forKey: "SiteListing")
        parameterDict.updateValue(staffMember?.firstName ?? "" , forKey: "staffName")
        parameterDict.updateValue(profile.siteCode ?? "", forKey: "siteCode")
        parameterDict.updateValue(staffMember?.staffCode ?? "", forKey: "staffCode")
        parameterDict.updateValue(profile.userID ?? "", forKey: "userID")
        
        WebService.shared.postDataFor(api: base + Apis.getStaffMember, parameters: parameterDict as [String : AnyObject]) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                if let dict = result.first {
                    self.staffMember = nil
                    self.staffMember = StaffMember(fromDictionary: dict)
                    self.displayValue(dict: dict as NSDictionary)
                }
            }
        }
    }
    
    private func displayValue (dict: NSDictionary) {
        if let showInsalesValue = dict["disc"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .discount){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = showInsalesValue
            arrAllowedOption[index] = allowedOption
        }
        if let showInTrmt = dict["isActive"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .userActive){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = showInTrmt
            arrAllowedOption[index] = allowedOption
        }
        if let showInAppt = dict["attnMarkUp"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .attendMakeUp){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = showInAppt
            arrAllowedOption[index] = allowedOption
        }
        if let allowCommition = dict["delMasterAirc"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .deleteArtical){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowCommition
            arrAllowedOption[index] = allowedOption
        }
        if let allowStaffPurchase = dict["voidTran"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .transactions){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowStaffPurchase
            arrAllowedOption[index] = allowedOption
        }
        if let allowStaffPurchase = dict["foc"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .foc){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowStaffPurchase
            arrAllowedOption[index] = allowedOption
        }
        if let allowStaffPurchase = dict["dayEndSettlement"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .settlement){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowStaffPurchase
            arrAllowedOption[index] = allowedOption
        }
        if let allowStaffPurchase = dict["sendEmail"] as?  Bool, let index = getIndexForAllowedOption(allowedOption: .sendEmail){
            var  allowedOption = arrAllowedOption[index]
            allowedOption.1 = allowStaffPurchase
            arrAllowedOption[index] = allowedOption
        }
        tblView.reloadData()
    }
    //MARK: Button action
    @IBAction func actionSelectOption(_ sender: UIButton) {
        var alloweddvalues = arrAllowedOption[sender.tag]
        alloweddvalues.1 = !alloweddvalues.1
        arrAllowedOption[sender.tag] = alloweddvalues
        tblView.reloadData()
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        parameterDict.updateValue(profile.siteCode ?? "", forKey: "siteCode")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .discount), forKey: "disc")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .userActive), forKey: "isActive")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .attendMakeUp), forKey: "attnMarkUp")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .deleteArtical), forKey: "delMasterAirc")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .transactions), forKey: "voidTran")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .foc), forKey: "foc")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .settlement), forKey: "dayEndSettlement")
        parameterDict.updateValue(getSelectedValueForAllowedOption(allowedOption: .sendEmail), forKey: "sendEmail")
        parameterDict.updateValue(staffCode ?? "", forKey: "staffCode")
        let vc = UpdateEmployeeStepFourVC.instantiateFrom(storyboard: .employee)
        vc.parameterDict = parameterDict
        vc.isComesFromUpdate = isComesFromEdit
        vc.staffCodeStrval = staffCode ?? ""
        vc.staffMember = staffMember
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func getSelectedValueForAllowedOption(allowedOption: AllowedOptionStepThree) -> Bool {
        let filtered = arrAllowedOption.filter{$0.0 == allowedOption}.first
        if let isSelected = filtered?.1 {
            return isSelected ? true : false
        }
        return false
    }

    private func getIndexForAllowedOption(allowedOption: AllowedOptionStepThree) -> Int? {
        let index = arrAllowedOption.firstIndex(where: { ($0.0 == allowedOption)})
        return index
    }
    //Call Create Employee Api
    func createEmployeeApi(parameter:[String:Any]){
        var siteCodeStr:String = ""
        let actionUrl = "\(base)\(Apis.createEmployee)"
        WebService.shared.postDataFor(api: actionUrl, parameters: parameter as [String : AnyObject]) { (sucess, response, msg) in
        }
    }
    
}
//MARK: UItableVwdelegate And UITableDataSources
extension UpdateEmplyoeeSteppThreeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllowedOption.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateEmployeeTVC", for: indexPath) as! CreateEmployeeTVC
        let alloweddvalues = arrAllowedOption[indexPath.row]
        cell.lblOptionName.text = alloweddvalues.0.rawValue
        cell.btnSelectOption.isSelected = alloweddvalues.1
        cell.btnSelectOption.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
