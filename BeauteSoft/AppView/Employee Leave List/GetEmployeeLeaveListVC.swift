//
//  GetEmployeeLeaveListVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 4/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class GetEmpListCell:UITableViewCell{
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var superContainerView: UIView!
    
    @IBOutlet var namebl: UILabel!
}

class GetEmployeeLeaveListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var listArrDict:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArrDict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GetEmpListCell") as! GetEmpListCell
        let item  =  listArrDict[indexPath.row]
         cell.superContainerView.dropShadow()
        if let userName = item["userName"] as? String{
            cell.namebl.text = userName
        }
        if let userName = item["date"] as? String{
            cell.dateLbl.text = userName
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
