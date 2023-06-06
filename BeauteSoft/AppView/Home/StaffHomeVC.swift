//
//  StaffHomeVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/3/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import SWRevealViewController
class HomeItemsCell:UITableViewCell {
    @IBOutlet var itemImg:UIButton!
    @IBOutlet var itemBtn:UIButton!
}

class StaffHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    
    enum HomeOptions: String {
        case siteManagement = "SITE MANAGEMENT", attendance = "ATTENDANCE", createWorkSchedule =  "CREATE WORK SCHEDULE", taskManagement = "TASK MANAGEMENT", history = "HISTORY", settings = "SETTINGS", report = "REPORT", employeeManagement = "EMPLOYEE MANAGEMENT",dashboard = "KPI DASHBOARD", bankIn = "BANK IN", customerCheckIn = "CUSTOMER CHECK IN", salesCommission = "SALES COMMISSION", appointmentList = "APPOINTMENT LIST"
    }
    //var arrHomeOptions: [(image: UIImage, option: HomeOptions)] = [(#imageLiteral(resourceName: "attendance"),.bankIn), (#imageLiteral(resourceName: "attendance"),.dashboard), (#imageLiteral(resourceName: "task management"),.taskManagement), (#imageLiteral(resourceName: "attendance"),.attendance), (#imageLiteral(resourceName: "work schedule"),.createWorkSchedule),(#imageLiteral(resourceName: "sit management"),.siteManagement), (#imageLiteral(resourceName: "attendance"),.employeeManagement), (#imageLiteral(resourceName: "history"),.history),(#imageLiteral(resourceName: "home_setting"),.settings),(#imageLiteral(resourceName: "attendance"),.report)]
    //var arrHomeOptions: [(image: UIImage, option: HomeOptions)] = [ (#imageLiteral(resourceName: "attendance"),.attendance),(#imageLiteral(resourceName: "home_setting"),.settings),(#imageLiteral(resourceName: "attendance"),.report), (#imageLiteral(resourceName: "task management"),.dashboard), (#imageLiteral(resourceName: "task management"),.salesCommission)]
    var arrHomeOptions: [(image: UIImage, option: HomeOptions)] = [ (#imageLiteral(resourceName: "attendance"),.attendance),(#imageLiteral(resourceName: "home_setting"),.settings)]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let localer = UserDefaults.standard.string(forKey: "locale")?.uppercased()  {
            if localer == "TNC"  {
                              arrHomeOptions.append((#imageLiteral(resourceName: "sit management"),.siteManagement))                
            } else if localer == "BEAUTY" || localer == "OHS"  {
                arrHomeOptions.append((#imageLiteral(resourceName: "sit management"),.siteManagement))
                arrHomeOptions.append((#imageLiteral(resourceName: "work schedule"),.createWorkSchedule))
                arrHomeOptions.append((#imageLiteral(resourceName: "attendance"),.employeeManagement))
                } else if localer == "OHC"  {
                    arrHomeOptions.append((#imageLiteral(resourceName: "attendance"),.bankIn))
                    arrHomeOptions.append((#imageLiteral(resourceName: "attendance"),.customerCheckIn))
                    arrHomeOptions.append((#imageLiteral(resourceName: "attendance"),.dashboard))
                    arrHomeOptions.append((#imageLiteral(resourceName: "sit management"),.siteManagement))
                    arrHomeOptions.append((#imageLiteral(resourceName: "work schedule"),.createWorkSchedule))
                    arrHomeOptions.append((#imageLiteral(resourceName: "attendance"),.employeeManagement))
                
            } else {
                arrHomeOptions.append((#imageLiteral(resourceName: "sit management"),.siteManagement))

                //    arrHomeOptions.append((#imageLiteral(resourceName: "sit management"),.siteManagement))
            //    arrHomeOptions.append((#imageLiteral(resourceName: "work schedule"),.createWorkSchedule))
            //    arrHomeOptions.append((#imageLiteral(resourceName: "attendance"),.employeeManagement))
            //    arrHomeOptions.append((#imageLiteral(resourceName: "task management"),.taskManagement))
//                arrHomeOptions.append((#imageLiteral(resourceName: "history"),.history))
            }
         }
        
        //arrHomeOptions.append((#imageLiteral(resourceName: "task management"),.appointmentList))
        
        if  let role = profile.role {
            if role == .staff {
                navigationTitleLbl.text = "Staff"
                btnNotification.isHidden = false
            } else{
                navigationTitleLbl.text = "Manager"
                btnNotification.isHidden = true
            }
        }
        
        //Load company Logo
        companyLogo.sd_setImage(with: URL(string: profile.clientLogo ?? ""), placeholderImage: UIImage(named: "beautesoft"))
        //Not used. Just tried
        //companyLogo.downloaded(from: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        revealController()
    }
    
    func revealController() {
        if self.revealViewController() != nil{
            if(revealViewController().frontViewPosition == FrontViewPosition.right){
                revealViewController().frontViewPosition = FrontViewPosition.left
            }
        }
    }
    
    @IBAction func selectItemBtnTap(_ sender: UIButton) {
        let homeOption = arrHomeOptions[sender.tag]
        switch homeOption.option {
        case .siteManagement:
            let vc = SalonDetailVC.instantiateFrom(storyboard: .siteManagement)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .taskManagement:
                let vc = TaskListVC.instantiateFrom(storyboard: .taskManagement)
                self.navigationController?.pushViewController(vc, animated: true)
            break
        case .createWorkSchedule:
            if let role = profile.role, role == .staff {
              let vc = WorkScheduleVC.instantiateFrom(storyboard: .workSchedule)
                //vc.staffMember = staffMember
              self.navigationController?.pushViewController(vc, animated: true)
            } else {
               let vc = StaffMemberVC.instantiateFrom(storyboard: .siteManagement)
               vc.screenOpenedFrom = .workSchedule
               vc.siteListing = [["siteCode": profile.siteListing[0].siteCode ?? ""]]
               self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case .attendance:
            let vc = AttendanceVC.instantiateFrom(storyboard: .attendance)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .history:
            let vc = TaskHistoryVC.instantiateFrom(storyboard: .history)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .report:
            let vc = ReportsVC.instantiateFrom(storyboard: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .settings:
            let settingsVC = SettingVC.instantiateFrom(storyboard: .settings)
            self.navigationController?.pushViewController(settingsVC, animated: true)
        case .employeeManagement:
            let vc = StaffMemberVC.instantiateFrom(storyboard: .siteManagement)
            vc.screenOpenedFrom = .employeeManagement
            vc.siteListing = [["siteCode": profile.siteListing[0].siteCode ?? ""]]
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .dashboard:
            let vc = DashboardVC.instantiateFrom(storyboard: .dashboard)
            self.navigationController?.pushViewController(vc, animated: true)
        case .bankIn:
            let vc = BankInViewController.instantiateFrom(storyboard: .dashboard)
            self.navigationController?.pushViewController(vc, animated: true)
        case .customerCheckIn :
            let vc = CustomerCheckInVC.instantiateFrom(storyboard: .customerCheckIn)
            self.navigationController?.pushViewController(vc, animated: true)
        case .salesCommission:
            if  let role = profile.role {
                if role == .staff {
                    let vc = SalesCommisionViewController.instantiateFrom(storyboard: .salesCommision)
                    vc.staffCode = profile.staffCode ?? ""
                    vc.staffName = profile.fullName ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = SelectStaffViewController.instantiateFrom(storyboard: .selectStaff)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case .appointmentList:
            if  let role = profile.role {
                if role == .staff {
                    let vc = AppointmentListViewController.instantiateFrom(storyboard: .appointmentList)
                    vc.staffCode = profile.staffCode ?? ""
                    vc.staffName = profile.fullName ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = SelectStaffViewController.instantiateFrom(storyboard: .selectStaff)
                    vc.isComingForAppointmentList = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    //Menu Button Action
    @IBAction func menuBtnAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func notificationClicked(_ sender: Any) {
        let notificationsVC = NotificationVC.instantiateFrom(storyboard: .notifications)
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    //UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemsCell") as! HomeItemsCell
        cell.selectionStyle = .none
        cell.itemBtn.tag = indexPath.row
        cell.itemBtn.setTitle(arrHomeOptions[indexPath.row].option.rawValue, for: .normal)
        cell.itemImg.setImage(arrHomeOptions[indexPath.row].image, for: .normal)
        if let role = profile.role, role == .staff, arrHomeOptions[indexPath.row].option == .createWorkSchedule {
            cell.itemBtn.setTitle("WORK SCHEDULE", for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menu = arrHomeOptions[indexPath.row]
        guard let role = profile.role else {
            return CGFloat.leastNormalMagnitude
        }
        switch menu.option {
        case .createWorkSchedule:
            return role == .manager ? 80 : CGFloat.leastNormalMagnitude
        case .siteManagement:
            return role == .manager ? 80 : CGFloat.leastNormalMagnitude
        case .employeeManagement:
            return role == .manager ? 80 : CGFloat.leastNormalMagnitude
        default:
            return 80
        }
    }
    
    
}

//Not used
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
