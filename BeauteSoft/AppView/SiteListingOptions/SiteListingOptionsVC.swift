//
//  SiteListingOptionsVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/10/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

protocol SiteListingOptionDelegate: class {
    func didSelectedSites(with result: [SiteListingOption])
}

class siteListingOptionCell:UITableViewCell{
    @IBOutlet var siteListingTF: UITextField!
    @IBOutlet var selectBtn:UIButton!
}

class submitListingCell:UITableViewCell{
    
}
class SiteListingOptionsVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet var tblView: UITableView!
    
    var staffMember: StaffMember?
    var arrOptionList = [SiteListingOption]()
    weak var delegate: SiteListingOptionDelegate?
    
    enum ScreenOpenedFrom: Int {
        case none
        case staffMemberProfile
        case outletSales
        case createEmployee
    }
    var screenOpenedFrom: ScreenOpenedFrom = .none
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllListingData()
    }
    //MARK: get options list
    func getAllListingData(){
        let actionURL = "\(base)\(Apis.getSiteListingOption)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: actionURL) { (sucess,response,msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrOptionList.append(SiteListingOption(fromDictionary: dict))
                })
                if self.screenOpenedFrom == .staffMemberProfile {
                    for item in self.arrOptionList{
                        self.staffMember?.siteListing.forEach{
                            if $0.siteCode == item.itemCode {
                                item.isSelected = true
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.delegate = self
                    self.tblView.dataSource = self
                    self.tbleView.reloadData()
                }
            }
        }
    }
    //MARK: - button action
    @IBAction func submitBtnTap(_ sender: Any) {
        switch screenOpenedFrom {
        case .staffMemberProfile, .outletSales, .createEmployee:
            let arrSelectedItems: [SiteListingOption] = (arrOptionList.filter{$0.isSelected})
            if arrSelectedItems.count == 0 {
                self.singleButtonAlertWith(message: .chooseOutlet)
            }else {
                delegate?.didSelectedSites(with: arrSelectedItems)
                self.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
        
//            siteDelegate.getSiteListing(siteListArr: containSelectedListArr,siteDescArr:containNameListArr)
//            self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func actionSlectedOption(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
       arrOptionList[sender.tag].isSelected = !arrOptionList[sender.tag].isSelected
       self.tblView.reloadData()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - tableView delegates and data sources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "siteListingOptionCell", for: indexPath) as! siteListingOptionCell
            cell.selectionStyle = .none
            let leftView = UILabel(frame: CGRect(x: 30, y: 0, width: 7, height: 26))
            leftView.backgroundColor = .clear
            cell.siteListingTF.leftView = leftView
            cell.siteListingTF.leftViewMode = .always
            cell.siteListingTF.contentVerticalAlignment = .center
            let listingItem = arrOptionList[indexPath.row]
            cell.siteListingTF.text = listingItem.itemDesc
            cell.selectBtn.isSelected = listingItem.isSelected
            cell.selectBtn.tag = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitListingCell") as! submitListingCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrOptionList.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
