//
//  CashVoucherDetailCell.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 05/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class CashVoucherDetailTVC: UITableViewCell {

    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblVoucherPrice: UILabel!
    var item: Any?{
        didSet{
            showDetail()
        }
    }
    var year: String?
    var month: String?
    var completionHandlerAlert: (()->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func showDetail() {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionUse(_ sender: Any) {
        let monthNewFormat  = Utility.shared.formattedStringFromGivenDate(fromFormat: "MMMM", toFormat: "MM", dateString: month ?? "")
        
        let parameter = ["siteCode": profile.siteCode ?? "","empCode": profile.staffCode ?? "","redeemCode": "","year": year ?? "", "month": monthNewFormat] as [String : AnyObject]
        let url = "\(baseDashboard)\(Apis.empAppCashVoucher)"
        WebService.shared.postDataFor(api: url, parameters: parameter) { (success, response, message) in
            if success {
                var respMessage: String?
                if let result = response["result"] as? String {
                    respMessage = result
                }
                if let obj = DashboardVC.shareInstance {
                    obj.singleButtonAlertWith( message: .custom(respMessage ?? ""), button: .ok, completionOnButton: {
                        self.completionHandlerAlert()
                         obj.getEmpAppDashboard()
                    })
                }
            }
        }

    }
}
