//
//  DashboardVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 05/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var tableViewDashboard: UITableView?{
        didSet {
        tableViewDashboard?.register(UINib(nibName: DashboardSectionHeader.identifier, bundle: nil), forCellReuseIdentifier: DashboardSectionHeader.identifier)
        tableViewDashboard?.register(UINib(nibName: CashVoucherHeader.identifier, bundle: nil), forCellReuseIdentifier: CashVoucherHeader.identifier)
        tableViewDashboard?.register(UINib(nibName: DashboardDetailTVC.identifier, bundle: nil), forCellReuseIdentifier: DashboardDetailTVC.identifier)
        tableViewDashboard?.register(UINib(nibName: CashVoucherDetailTVC.identifier, bundle: nil), forCellReuseIdentifier: CashVoucherDetailTVC.identifier)
        tableViewDashboard?.register(UINib(nibName: CashVoucherExpireTVC.identifier, bundle: nil), forCellReuseIdentifier: CashVoucherExpireTVC.identifier)
        }
    }
    
    var arrDashboard: [Dashboard]?
    var dashboard = Dashboard()
    weak static var shareInstance : DashboardVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        DashboardVC.shareInstance = self
        getEmpAppDashboard()
    }
    @IBAction func actionBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    //GetDepartment List
    func getEmpAppDashboard(){
        let url = "\(baseDashboard)\(Apis.empAppDashBoard)\(profile.siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [String: Any] {
                self.dashboard.setValue(fromDictionary: result as [String : AnyObject])
                self.tableViewDashboard?.delegate = self
                self.tableViewDashboard?.dataSource = self
                self.tableViewDashboard?.reloadData()
            }
        }
    }

}
