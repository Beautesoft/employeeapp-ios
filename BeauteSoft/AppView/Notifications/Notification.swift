//
//  Notification.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 02/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class Notification {
    
    var message : String?
    var notificationID : String?
    var notifyDate : String?
    var notifytime : String?
    var phoneNumber : String?
    var remarks : String?
    var siteCode : String?
    var status : String?
    var userID : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        notificationID = dictionary["notificationID"] as? String
        notifyDate = dictionary["notifyDate"] as? String
        notifytime = dictionary["notifytime"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
        remarks = dictionary["remarks"] as? String
        siteCode = dictionary["siteCode"] as? String
        status = dictionary["status"] as? String
        userID = dictionary["userID"] as? String
    }
    
}
