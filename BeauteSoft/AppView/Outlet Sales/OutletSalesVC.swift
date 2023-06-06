//
//  OutletSalesVC.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 27/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class OutletSalesVC: UIViewController, SiteListingOptionDelegate {
    

    var checkInt:Int = -1
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var toDateOutlet: UIButton!
    @IBOutlet var fromDateBtn: UIButton!
    @IBOutlet var datePickerContainerView: UIView!
    @IBOutlet weak var btnChooseOutlet: UIButton!
    
    var fromDate:String = ""
    var toDate:String = ""
    var getSalesDict:[[String:Any]] = []
    var arrOutlets =  [SiteListingOption]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
    }
    
    @IBAction func datePickerValChanged(_ sender: Any) {
        setDateToFields()
    }
    
    func setDateToFields() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        if checkInt  == 1{
            let strDate = dateFormatter.string(from: datePicker.date)
            fromDate  = strDate
            fromDateBtn.setTitle(strDate, for: .normal)
            // amontDateFrom1 = strDate
        }else{
            let strDate = dateFormatter.string(from: datePicker.date)
            toDate = strDate
            toDateOutlet.setTitle(strDate, for: .normal)
        }
    }
    
    @IBAction func toDateBtnTap(_ sender: Any) {
        checkInt = 0
        if datePickerContainerView.isHidden{
            datePickerContainerView.isHidden = false
        }else{
            datePickerContainerView.isHidden = true
        }
    }
    @IBAction func fromDateBTnTap(_ sender: Any) {
        checkInt = 1
        if datePickerContainerView.isHidden{
            datePickerContainerView.isHidden = false
        }else{
            datePickerContainerView.isHidden = true
        }
    }
    @IBAction func actionChooseOutlet(_ sender: Any) {
        let vc =  SiteListingOptionsVC.instantiateFrom(storyboard: .siteManagement)
        vc.screenOpenedFrom = .outletSales
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitBtnTap(_ sender: Any) {
        if fromDate == ""{
            singleButtonAlertWith(message: .chooseFromDate)
        } else if toDate == ""{
            singleButtonAlertWith(message: .chooseToDate)
        } else if arrOutlets.count == 0 {
            singleButtonAlertWith(message: .chooseOutlet)
        } else{
            let siteListing = Utility.shared.getSiteListingParameter(siteListingOption: arrOutlets)
            let param = ["SiteListing": siteListing, "fromDate": fromDate, "toDate": toDate] as [String : Any]
            WebService.shared.postDataFor(api: base + Apis.getOutletSales, parameters: param as [String : AnyObject] ){ (success, response, result) in
                if let result = response["result"] as? [[String:Any]]{
                    self.getSalesDict = result
                    self.goToNextVC()
                }
            }
        }
        
    }
    
    func didSelectedSites(with result: [SiteListingOption]) {
        let title = result.map( {$0.itemDesc ?? ""}).joined(separator: ",")
        btnChooseOutlet.setTitle(title, for: .normal)
        arrOutlets = result
    }
    
    func goToNextVC(){
        let vc = OutletSalesResultVC.instantiateFrom(storyboard: .reports)
        vc.salesResult =  self.getSalesDict
        vc.fromDate = fromDate
        vc.toDate = toDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func donebtnTap(_ sender: Any) {
        setDateToFields()
        datePickerContainerView.isHidden = true
    }
    
}
