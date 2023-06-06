//
//  ServiceTypeVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/7/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

protocol SelectedServiceType: class {
    func didSelectedResult(_ arrSelectedIds: [String],selectedDepartment: DepartmentList?)
}

class ServiceTypeCell:UITableViewCell{
    
    @IBOutlet var selectTypeBtn: UIButton!
    @IBOutlet var serviceTypeTF: UITextField!
}

class submitCell:UITableViewCell{
    
}
class ServiceTypeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var serviceTypTblView: UITableView!
    
    var serviceTypeArr:[[String:Any]] = []
    var selectedCells:[Int] = []
    var selectedServiceIdArr:[String] = []
    var departmentId:String = ""
    var arrServiceType = [ServiceType]()
    var arrIdsSelected = [String]()
    var selectedDeparment: DepartmentList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDepartmentServiceType()
    }
    
    //GetDepartment List
    func getDepartmentServiceType(){
        let url = "\(base)\(Apis.getServiceType)\(profile.siteCode ?? "")&departmentID=\(departmentId)"
        WebService.shared.getDataFrom(api: url) { (scuess, response, msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrServiceType.append(ServiceType(fromDictionary: dict))
                })
                for item in self.arrServiceType{
                   self.arrIdsSelected.forEach({ (id) in
                        if id == item.stockCode {
                            item.isSelected = true
                        }
                    })
                }
                self.tblView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTypeCell", for:  indexPath) as! ServiceTypeCell
            cell.selectionStyle = .none
            let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 7, height: 26))
            leftView.backgroundColor = .clear
            let servcieType = arrServiceType[indexPath.row]
            let paddingView = UIView(frame: CGRect(x: 5, y: 0, width: 15, height: cell.serviceTypeTF.frame.height))
            cell.serviceTypeTF.leftView = paddingView
            cell.serviceTypeTF.leftViewMode = UITextField.ViewMode.always
            cell.selectTypeBtn.isSelected = servcieType.isSelected
            cell.serviceTypeTF.text = servcieType.stockName
            cell.selectTypeBtn.tag = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCell") as! submitCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrServiceType.count
        }else{
            return 1
        }
    }
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        let arrIds = arrServiceType.filter{
            $0.isSelected
            }.map{$0.stockCode ?? ""}
        arrIdsSelected = arrIds
        print(arrIds)
        delegateSelectedServiceType?.didSelectedResult(arrIds, selectedDepartment: selectedDeparment)
        GlobalBaseClass.departmentServiceId = arrIds.joined(separator: ",")
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in  viewControllers{
                if vc is TaskCreationVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    @IBAction func actionSelectServiceType(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        arrServiceType[sender.tag].isSelected = !arrServiceType[sender.tag].isSelected
        self.tblView.reloadData()
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
