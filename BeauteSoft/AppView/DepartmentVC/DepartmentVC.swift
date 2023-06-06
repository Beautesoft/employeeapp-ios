//
//  DepartmentVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/15/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

struct GlobalBaseClass{
    static var departmentId:String = ""
    static var departmentServiceId:String = ""
}

class DepartmentCell:UITableViewCell{
    
    @IBOutlet weak var btnSelectedDepartment: UIButton!
    @IBOutlet var departmentTF: UITextField!
}

class DepartmentVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var departmentTblView: UITableView!
    var departmentListArrDict:[[String:Any]] = []
    var departmentArr:[String] = ["10X ADD ON (PV)","10X TREATMENT (PV)","1ST Trial","5X ADD ON (PV)","5X TREATMENT (PV)","ADD ON (OLD BILL)","ADD ON AD HOC","ADD ON REGULAR","COMPLIMENTARY"]
    var arrDepartmentList = [DepartmentList]()
    var arrSelectedServiceTypeIds = [String]()
    var selectedDepartment: DepartmentList?
    var selectedDepartMentCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDepartmentList()
        // Do any additional setup after loading the view.
    }
    //GetDepartment List
    func getDepartmentList(){
        let url = "\(base)\(Apis.getDepartmentList)\(profile.staffCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                self.arrDepartmentList.removeAll()
                result.forEach({ (dict) in
                    self.arrDepartmentList.append(DepartmentList(fromDictionary: dict))
                    
                })
                for item in self.arrDepartmentList{
                        if self.selectedDepartMentCode == item.departmentCode {
                            item.isSelected = true
                        }
                }
                self.departmentTblView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell") as! DepartmentCell
        cell.selectionStyle = .none
        let paddingView = UIView(frame: CGRect(x: 5, y: 0, width: 15, height: cell.departmentTF.frame.height))
        cell.departmentTF.leftView = paddingView
        cell.departmentTF.leftViewMode = UITextField.ViewMode.always
        let departmentList = arrDepartmentList[indexPath.row]
        cell.departmentTF.text = departmentList.departmentName ?? ""
        cell.btnSelectedDepartment.isSelected = departmentList.isSelected
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrDepartmentList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelDepartment = arrDepartmentList[indexPath.row]
        let vc = ServiceTypeVC.instantiateFrom(storyboard: .taskManagement)
        vc.departmentId = modelDepartment.departmentCode ?? ""
        vc.selectedDeparment = modelDepartment
       
        if self.selectedDepartMentCode == modelDepartment.departmentCode {
            vc.arrIdsSelected = arrSelectedServiceTypeIds
            GlobalBaseClass.departmentId = modelDepartment.departmentCode ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            vc.arrIdsSelected = []
            GlobalBaseClass.departmentId = modelDepartment.departmentCode ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
