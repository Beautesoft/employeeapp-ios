//
//  CustomerArrivedVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 04/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class CustomerArrivedVC: UIViewController {
  
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAppoinmentCode: UILabel!
    @IBOutlet weak var lblTreatment: UILabel!
    var dict: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    private func showData() {
        if let temp = dict?["customerName"] as? String {
            self.lblCustomerName.text = temp
        }
        if let temp = dict?["treatmentName"] as? String {
            self.lblTreatment.text = temp
        }
        if let temp = dict?["appointmentCode"] as? String {
            self.lblAppoinmentCode.text = temp
        }
        if let temp = dict?["appointmentTime"] as? String {
            self.lblTime.text = temp
        }
    }
    @IBAction func actionBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionArrived(_ sender: Any) {
        guard let appointmentCode = dict?["appointmentCode"] as? String  else {
            return
        }
        let parameter = ["siteCode": profile.siteCode ?? "","appointmentCode": appointmentCode,"staffCode": profile.staffCode ?? "","userID": profile.userID ?? "", "status": "ARRIVED"] as [String : AnyObject]
        let url = "\(baseDashboard)\(Apis.markArrived)"
        WebService.shared.postDataFor(api: url, parameters: parameter) { (success, response, message) in
            if success {
                var respMessage = "Appointment updated successfully"
                if let result = response["result"] as? String {
                    respMessage = result
                }
                self.singleButtonAlertWith( message: .custom(respMessage), button: .ok, completionOnButton: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }

    }
}
