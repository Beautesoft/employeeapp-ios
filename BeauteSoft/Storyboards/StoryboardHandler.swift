//  StoryboardHandler.swift
//  Basic
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import UIKit

enum Storyboards : String {
    case prelogin = "Main", homeflow = "HomeFlow", settings = "Settings", profile = "Profile", siteManagement = "SiteManagement", reports = "Reports", history = "History", attendance = "Attendance", notifications = "Notifications", workSchedule = "WorkSchedule", taskManagement = "TaskManagement" , employee = "EmployeeManagement", leaveManagement = "LeaveManagement", customerCheckIn = "CustomerCheckIn", dashboard = "Dashboard", selectStaff = "SelectStaff", salesCommision = "SalesCommision", appointmentList = "AppointmentList"
 //enum Storyboards : String {
   // case prelogin = "Main", homeflow = "HomeFlow", settings = "Settings", profile = "Profile", siteManagement = "SiteManagement", attendance = "Attendance", notifications = "Notifications", workSchedule = "WorkSchedule"

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(_ controller: T.Type) -> T {
        let storyId = (controller as UIViewController.Type).storyboardId
        return instance.instantiateViewController(withIdentifier: storyId) as! T
    }
}

extension UIViewController {
    class var storyboardId: String {
        return "\(self)"
    }
    
    /**
     This is a method to instatiate a view controller from a storyboard.
     - parameter storyboard: An object of type Storyboards that contains the desired view controller
     * the only rule here is that you should keep the storyboardId in the storyboard similar to the name of the viewController, if not then provide your storyboardId before instantiating your viewController.
     * It can be used as --->
     * let homeScene = HomeVC.instantiateFrom(storyboard: .main)
     */
    static func instantiateFrom(storyboard: Storyboards) -> Self {
        return storyboard.viewController(self)
    }
}
