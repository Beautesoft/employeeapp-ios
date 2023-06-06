//
//  ListTopperVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit


class employeeSalesListCell:UITableViewCell{
    
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var employeeNamLbl: UILabel!
}
class ListTopperVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    var isComingFrom:Bool = false
    var fromDate:String = ""
    var toDate:String = ""
    var isSale:Bool = false
    var urlStr:String = ""
    var empoyeeDict:[[String:Any]] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var employeeTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getList()
        lblTitle.text = "From \(fromDate) to \(toDate)"
    }
    
    func getList(){
        if isComingFrom == false{
            callSaleDataApi()
        }else{
            callTDDataApi()
        }
        
    }
    
    func callSaleDataApi(){
        if isSale == false{
            urlStr = Apis.getTop10Sales
        }else{
            urlStr = Apis.getPoor10Sales
        }
        let sideCode = profile.siteCode ?? ""
        var param:[String:Any] = [:]
        param = ["siteCode":sideCode,"fromDate":fromDate,"toDate":toDate]
        WebService.shared.postDataFor(api: base + urlStr, parameters: param as [String : AnyObject]) { (success, response, message) in
            print(response)
            if success {
                if let result = response["result"] as? [[String:Any]]{
                    self.empoyeeDict = result
                }
            }
            self.employeeTblView.reloadData()
        }
    }
    
    func callTDDataApi(){
        if isSale == false{
            urlStr = Apis.getTop10TD
        }else{
            urlStr = Apis.getPoor10TD
        }
        let sideCode = profile.siteCode ?? ""
        let param = ["siteCode":sideCode,"fromDate":fromDate,"toDate":toDate]
        WebService.shared.postDataFor(api: base + urlStr, parameters: param as [String : AnyObject]) { (success, response, message) in
            print(response)
            if success {
                if let result = response["result"] as? [[String:Any]]{
                    self.empoyeeDict = result
                }
            }
            self.employeeTblView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empoyeeDict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeSalesListCell") as! employeeSalesListCell
        cell.selectionStyle = .none
        let empDict = empoyeeDict[indexPath.row]
        if let employeeName = empDict["employeeName"] as? String{
            cell.employeeNamLbl.text = employeeName
        }
        if let employeeName = empDict["amount"] as? String{
            cell.amountLbl.text = employeeName
        } else if let employeeName = empDict["amount"] as? NSNumber{
            cell.amountLbl.text = "\(employeeName.doubleValue)"
        }
        return cell
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
