//
//  TaskHistoryVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/4/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import SWRevealViewController

class HistoryCell:UITableViewCell{
    
    @IBOutlet var customerNamelbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var taskTileLbl: UILabel!
}

class TaskHistoryVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,SWRevealViewControllerDelegate{

    @IBOutlet var historyTblView: UITableView!
    @IBOutlet weak var statusTF: UITextField!
    var statusArr:[String] = ["Accepted","Declined","Confirmed","Completed","Cancelled","Open"]
    var picker =  UIPickerView()
    var arrHistoryList = [TaskHistory]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setPicker()
        getTaskHistory()
    }
    //MARK: api get history
    func getTaskHistory(){
        let parameter = ["userID": profile.userID ?? "","status":"Completed","siteCode": profile.siteCode]
        let url = "\(base)\(Apis.getHistoryAndPastJobs)"
        WebService.shared.postDataFor(api: url, parameters: parameter as [String : AnyObject]) { (sucess, response,msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.arrHistoryList.append(TaskHistory(fromDictionary: dict))
                })
                self.historyTblView.reloadData()
            }
        }
    }
    //UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.selectionStyle = .none
        let modelHistory = arrHistoryList[indexPath.row]
        cell.customerNamelbl.text = modelHistory.customerName ?? ""
        cell.imgView.sd_setImage(with: URL(string: modelHistory.customerPic ?? "") , placeholderImage: nil)
        cell.taskTileLbl.text = modelHistory.taskTitle
        cell.descLbl.text = modelHistory.descriptionTask
        cell.startDate.text = modelHistory.startDate
        if let startTime = modelHistory.startTime{
            if let endTime = modelHistory.endTime{
                cell.startDate.text = startTime + "-" + endTime
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // SET PICKER
    func setPicker(){
        picker = UIPickerView(frame: CGRect(x:0, y:200, width:view.frame.width,height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        statusTF.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        statusTF.inputAccessoryView = toolBar
        
    }
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  self.statusArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let selectedcategory = statusArr[row]
        return selectedcategory
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        let categoryList =  self.statusArr[row]
       
        statusTF.text = categoryList
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @objc func donePicker(){
        self.view.endEditing(true)
    }
    //Reveal view controller
    func revealController() {
        if self.revealViewController() != nil{
            if(revealViewController().frontViewPosition == FrontViewPosition.right){
                revealViewController().frontViewPosition = FrontViewPosition.left
            }
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
    }
    
}
