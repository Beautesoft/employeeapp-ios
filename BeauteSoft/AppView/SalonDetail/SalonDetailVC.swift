//
//  SalonDetailVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/9/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class SalonDetailCell:UITableViewCell{
    
    @IBOutlet weak var locationNamLbl: UILabel!
    @IBOutlet weak var salonNameLbl: UILabel!
    @IBOutlet weak var vwRating: FloatRatingView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    
}

class SalonDetailVC: UIViewController {
    
    @IBOutlet weak var vwLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchStaffMember: UISearchBar!
    
    var filtering = false
    var filteredArr = [SaloonList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchStaffMember.delegate = self
        vwLeadingConst.constant = 410
        getSaloonList()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var saloonListArr:[[String:Any]]=[]
    var arrSallonList = [SaloonList]()
    //Get Saloon list
    func getSaloonList(){
        let api = base + Apis.getSaloonList
        let userId = profile.userID ?? ""
        let url = api + "" + "&" + "userID=" + userId
        WebService.shared.getDataFrom(api: url) { (sucess,response,msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrSallonList.append(SaloonList(fromDictionary: dict))
                })
                self.arrSallonList = self.arrSallonList.sorted { ($0.siteName ?? "" ) < ($1.siteName ?? "" ) }
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func actionSearch(_ sender: Any) {
        self.filtering = false
        self.filteredArr = []
        vwLeadingConst.constant = 0
        searchStaffMember.becomeFirstResponder()
    }
    
    @IBAction func actionHideSearch(_ sender: Any) {
        vwLeadingConst.constant = 410
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SalonDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtering ? self.filteredArr.count : arrSallonList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalonDetailCell") as! SalonDetailCell
        cell.selectionStyle = .none
        let saloonList = self.filtering ? self.filteredArr[indexPath.row] : arrSallonList[indexPath.row]
        cell.salonNameLbl.text = saloonList.siteName
        cell.locationNamLbl.text =  saloonList.location
        cell.vwRating.rating = saloonList.rating ?? 0.0
        cell.imgProfilePic.sd_setImage(with: URL(string: saloonList.displayPic ?? "") , placeholderImage: UIImage(named: "member_icon"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let saloonList = self.filtering ? self.filteredArr[indexPath.row] : arrSallonList[indexPath.row]
      let vc = BeautyContentVC.instantiateFrom(storyboard: .siteManagement)
      vc.saloonListModel = saloonList
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
extension SalonDetailVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            print(searchText)
            self.filteredArr = self.arrSallonList.filter { ($0.siteName?.localizedCaseInsensitiveContains(searchText))!
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
