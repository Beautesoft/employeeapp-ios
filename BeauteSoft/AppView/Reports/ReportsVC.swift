//
//  ReportsVC.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 24/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class ReportsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reportsSection = ReportsSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemsCell") as! HomeItemsCell
        cell.selectionStyle = .none
        cell.itemBtn.tag = indexPath.row
        cell.itemBtn.isUserInteractionEnabled = false
        switch reportsSection {
        case .sale:
            cell.itemBtn.setTitle("Toppers and Lowers Sale", for: .normal)
        case .td:
            cell.itemBtn.setTitle("Topers TD and Lowers TD", for: .normal)
        case .leave:
            cell.itemBtn.setTitle("List Employee Leave", for: .normal)
        case .outletSale:
            cell.itemBtn.setTitle("Outlet Sale", for: .normal)
        default:
           break
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReportsSection.count.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = ReportsSection(rawValue: section) else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = ReportsSection(rawValue: indexPath.section) else {
            return CGFloat.leastNormalMagnitude
        }
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reportsSection = ReportsSection(rawValue: indexPath.section) else {
            return
        }
        switch reportsSection {
        case .sale:
            let vc = ToppersSaleVC.instantiateFrom(storyboard: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
        case .td:
            let vc = GetTDVC.instantiateFrom(storyboard: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
        case .leave:
            let vc = EmployeeLeaveListVC.instantiateFrom(storyboard: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
        case .outletSale:
            let vc = OutletSalesVC.instantiateFrom(storyboard: .reports)
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }
}
