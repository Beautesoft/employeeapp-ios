//
//  WorkScheduleVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import FSCalendar
class WorkSchedulecell:UITableViewCell{
    
    @IBOutlet weak var vwColor: UIView!
    @IBOutlet weak var lblSelectListing: UILabel!
    @IBOutlet var dropDownBtn: UIButton!
    @IBOutlet var scheduleTxtLbl: UILabel!
    @IBOutlet var superContainerView: UIView!
    @IBOutlet var scheduleTimLbl: UILabel!
}

class WorkScheduleVC: UIViewController,UITableViewDataSource,UITableViewDelegate,WorkScheduleData, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var lblNameAndCode: UILabel!
    @IBOutlet var workScheduleTblView: UITableView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
  
    var scheduleArrDict:[[String:Any]] = []
    var startDate:String = ""
    var endDate:String = ""
    var workScheduleId:String = ""
    var selectedDateStr:String = ""
    var todayDate = NSDate()
    var minDate = NSDate()
    var maxDate = NSDate()
    var dateSelected = NSDate()
    var staffMember: StaffMember?
    var arrScheduledList = [ScheduledList]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy/MM/dd")
       //2019/07/19
        selectedDateStr = currentDate
        workScheduleTblView.estimatedRowHeight = 110
        if let role = profile.role, role == .staff {
            addBtn.isHidden = true
            lblNameAndCode.text = "\(profile.firstName ?? "")\(profile.lastName ?? "") (\(profile.staffCode ?? ""))"
        }else {
          lblNameAndCode.text = "\(staffMember?.firstName ?? "")\(staffMember?.lastName ?? "") (\(staffMember?.staffCode ?? ""))"
        }
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2.0))
        calendarView = calendar
        calendarView.layer.cornerRadius = 10
        calendar.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        getWorkScheduleList()
    }
    //MARK: - Work Scheduled list
    func getWorkScheduleList() {
        var userId: String?
        var siteCode: String?
        if arrScheduledList.count == 0 {
            self.workScheduleTblView.isHidden = true
        }
        if let role = profile.role, role == .staff {
            userId = profile.userID ?? ""
            siteCode = profile.siteCode ?? ""
        } else {
            userId = staffMember?.userLogin?.lowercased() ?? ""
            siteCode = staffMember!.siteListing.compactMap{ $0.siteCode }.joined(separator: ",")
        }
        let url = "\(base)\(Apis.getWorkScheduledList)\(userId ?? "")&date=\(selectedDateStr)&siteCode=\(siteCode ?? "")"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            self.arrScheduledList.removeAll()
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.workScheduleTblView.isHidden = false
                    self.arrScheduledList.append(ScheduledList(fromDictionary: dict))
                })
            }
            self.workScheduleTblView.reloadData()
        }
    }
    //MARK: - Work Schedule delegates
    func workScheduleData(workscheduleId: String, startDate: String, endDate: String) {
        self.workScheduleId = workscheduleId
        self.startDate = startDate
        self.endDate = endDate
    }
    //MARK: - Button action
    @IBAction func dropDownBtnTap(_ sender: UIButton) {
        if let role = profile.role, role == .staff {
            addBtn.isHidden = true
        }else {
            addBtn.isHidden = false
            let model = arrScheduledList[sender.tag]
            let vc = CreateWorkScheduleVC.instantiateFrom(storyboard: .workSchedule)
            vc.isComeFromUpdate = true
            vc.scheduledListModel = model
            vc.workScdeuleDelegate = self
            vc.staffMember = staffMember
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addBtnTap(_ sender: Any) {
        let vc = CreateWorkScheduleVC.instantiateFrom(storyboard: .workSchedule)
        vc.workScdeuleDelegate = self
        vc.staffMember = staffMember
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- tableView Delegates and DataSources
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSchedulecell") as! WorkSchedulecell
        cell.selectionStyle = .none
        cell.superContainerView.addShadow(offset: CGSize(width: 2.0, height: 2.0), color: .lightGray, radius: 2.0, opacity: 0.4)
        let model = arrScheduledList[indexPath.row]
        cell.lblSelectListing.text = model.siteName ?? ""
        cell.scheduleTxtLbl.text = model.title
       // 2020/06/14  dd/MM/yyyy
        let startDate = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd", toFormat: "dd/MM/yyyy", dateString: model.startDate ?? "")
        let endDate = Utility.shared.formattedStringFromGivenDate(fromFormat: "yyyy-MM-dd", toFormat: "dd/MM/yyyy", dateString: model.endDate ?? "")
        cell.scheduleTimLbl.text = startDate + "-" + endDate
        if let hexColor = model.typeCodeColor {
            cell.vwColor.backgroundColor = Utility.shared.hexStringToUIColor(hex: hexColor)
        }else {
          cell.vwColor.backgroundColor = AppInfo.appColor
        }
        
        cell.dropDownBtn.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrScheduledList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //MARk: - calender delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy/MM/dd"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        print(myStringafd)
        selectedDateStr = myStringafd
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        getWorkScheduleList()
    }
}
