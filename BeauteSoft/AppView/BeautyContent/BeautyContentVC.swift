//
//  BeautyContentVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/9/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class ContentCell:UITableViewCell{
    
    @IBOutlet weak var vwRating: FloatRatingView!
    @IBOutlet weak var imgSaloon: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var lblSaloonName: UILabel!
}

class MembersCountCell:UITableViewCell{
    
    @IBOutlet weak var memberTitleLbl: UILabel!
    @IBOutlet weak var membersCountLbl: UILabel!
}
class DescriptionCell:UITableViewCell{
    
}
class BeautyContentVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
  
    var getSaloonListDict:[String:Any]=[:]
    var saloonDetailArr:[[String:Any]]=[]
    var saloonListModel: SaloonList?
    var arrSallonDetail = [SaloonList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getSaloonDetail()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getSaloonDetail(){
        let siteCode = saloonListModel?.siteCode ?? ""
        let userid = profile.userID ?? ""
        let url = base + Apis.getSaloondetail
        let actionURL = url + siteCode + "&" + "userID=" + userid
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response, msg) in
            self.arrSallonDetail.removeAll()
          if let result = response["result"] as? [[String:Any]] {
            result.forEach({ (dict) in
                self.arrSallonDetail.append(SaloonList(fromDictionary: dict))
                self.tableView.reloadData()
            })
          }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell") as! ContentCell
        cell.selectionStyle = .none
            let saloonDetail = arrSallonDetail[0]
                if saloonDetail.location == ""{
                    cell.locationLbl.text = "location:"
                }else{
                    cell.locationLbl.text = "location: " + saloonDetail.location!
                }
                if saloonDetail.description == ""{
                    cell.descriptionLbl.text = "Description:"
                }else{
                    cell.descriptionLbl.text = "Description: " + saloonDetail.description!
                }
            cell.vwRating.rating = saloonListModel?.rating ?? 0.0
            cell.lblSaloonName.text = saloonDetail.siteName
        return cell
        } else  if indexPath.section == 1 || indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MembersCountCell") as! MembersCountCell
             let saloonDetail = arrSallonDetail[0]
             cell.selectionStyle = .none
              
            if indexPath.section == 1 {
                cell.memberTitleLbl.text = "Active Staff Members"
                    if saloonDetail.numberOfStaffMember == ""{
                        cell.membersCountLbl.text = "Members:"
                    }else{
                        cell.membersCountLbl.text = "Members: " + saloonDetail.numberOfStaffMember!
                    }
            }else {
                cell.memberTitleLbl.text = "Inactive Staff Members"
                if saloonDetail.numberOfInactiveStaffs == ""{
                    cell.membersCountLbl.text = "Members:"
                }else{
                    cell.membersCountLbl.text = "Members: " + saloonDetail.numberOfInactiveStaffs!
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
             cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSallonDetail.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 350
        } else if indexPath.section == 1 || indexPath.section == 2{
            return 80
        }else{
            return 200
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 || indexPath.section == 2{
          let vc = StaffMemberVC.instantiateFrom(storyboard: .siteManagement)
            vc.siteListing = [["siteCode": saloonListModel?.siteCode ?? ""]]
            vc.isActive =  indexPath.section == 1 ? "1" : "0"
          self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
