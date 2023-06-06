//
//  SideBarMenuVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/3/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import SDWebImage
class SideMenuCell:UITableViewCell{
    @IBOutlet var titleLbl:UILabel!
    @IBOutlet var itemImageView: UIImageView!
}

class SideBarMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var sideMenuTblView: UITableView!
    @IBOutlet var profilePicImgView: UIImageView!
    
    @IBOutlet var userNamelbl: UILabel!
    
    enum MenuOptions: String {
//        case home = "Home", pastJob = "Past Job", leaveManagement = "Leave Management", profile = "Profile", notification = "Notification", settings = "Settings"
        case home = "Home", leaveManagement = "Leave Management", profile = "Profile", notification = "Notification", settings = "Settings"
    }
//    var arrMenuOptions: [(image: UIImage, option: MenuOptions)] = [(#imageLiteral(resourceName: "home"),.home), (#imageLiteral(resourceName: "past_job"),.pastJob), (#imageLiteral(resourceName: "past_job"),.leaveManagement),(#imageLiteral(resourceName: "profile"),.profile), (#imageLiteral(resourceName: "notification"),.notification),(#imageLiteral(resourceName: "setting"),.settings)]
    
    var arrMenuOptions: [(image: UIImage, option: MenuOptions)] = [(#imageLiteral(resourceName: "home"),.home), (#imageLiteral(resourceName: "past_job"),.leaveManagement),(#imageLiteral(resourceName: "profile"),.profile), (#imageLiteral(resourceName: "notification"),.notification),(#imageLiteral(resourceName: "setting"),.settings)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        if  let profilePic = profile.profilePic {
            profilePicImgView.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(named: "profile"))
        }
        userNamelbl.text = profile.fullName ?? ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.titleLbl.text = arrMenuOptions[indexPath.row].option.rawValue
        cell.itemImageView.image = arrMenuOptions[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.revealViewController().revealToggle(true)
        let menu = arrMenuOptions[indexPath.row]
        switch menu.option {
        case .home:
            //self.revealViewController().revealToggle(true)
            break
//        case .pastJob:
//            let myVC = TaskHistoryVC.instantiateFrom(storyboard: .history)
//            navigationController?.pushViewController(myVC, animated: true)
//            break
        case .leaveManagement:
            if let role = profile.role, role == .staff {
                let vc = AplliedLeaveListVC.instantiateFrom(storyboard: .leaveManagement)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = LeaveStatusVC.instantiateFrom(storyboard: .leaveManagement)
                self.navigationController?.pushViewController(vc, animated: true)

            }
            break
        case .profile:
            let myVC = ProfileVC.instantiateFrom(storyboard: .profile)
            navigationController?.pushViewController(myVC, animated: true)
            break
        case .notification:
            let notificationsVC = NotificationVC.instantiateFrom(storyboard: .notifications)
            navigationController?.pushViewController(notificationsVC, animated: true)
        case .settings:
            let settingsVC = SettingVC.instantiateFrom(storyboard: .settings)
            self.navigationController?.pushViewController(settingsVC, animated: true)
            break
        }
        
    }
}
