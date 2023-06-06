//
//  OutletSalesResultVC.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 27/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class OutletSalesResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var fromDate:String = ""
    var toDate:String = ""
    var salesResult: [[String:Any]] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "From \(fromDate) to \(toDate)"
    }
    
   
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salesResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutletSalesTVC") as! OutletSalesTVC
        cell.selectionStyle = .none
        let salesDict = salesResult[indexPath.row]
        if let employeeName = salesDict["outletName"] as? String{
            cell.lblSiteName.text = employeeName
        }
        if let employeeName = salesDict["totalSale"] as? String{
            cell.lblTotalSale.text = employeeName
        } else if let employeeName = salesDict["totalSale"] as? NSNumber{
            cell.lblTotalSale.text = "\(employeeName.doubleValue)"
        }
        
        if let employeeName = salesDict["totalTD"] as? String{
            cell.lblTotalTD.text = employeeName
        } else if let employeeName = salesDict["totalTD"] as? NSNumber{
            cell.lblTotalTD.text = "\(employeeName.doubleValue)"
        }
        
        if let employeeName = salesDict["totalPersonDoingTD"] as? String{
            cell.lblTotalPersonDoingTD.text = employeeName
        } else if let employeeName = salesDict["totalPersonDoingTD"] as? NSNumber{
            cell.lblTotalPersonDoingTD.text = "\(employeeName.doubleValue)"
        }
        
        if let employeeName = salesDict["totalPersonDoingSale"] as? String{
            cell.lblTotalPersonDoingSale.text = employeeName
        } else if let employeeName = salesDict["totalPersonDoingSale"] as? NSNumber{
            cell.lblTotalPersonDoingSale.text = "\(employeeName.doubleValue)"
        }
        return cell
    }
}
