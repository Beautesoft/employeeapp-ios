//
//  ScheduledList.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 04/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation

class ScheduledList{
    
    var comments : String!
    var endDate : String!
    var managerID : String!
    var scheduleID : String!
    var scheduleType : String!
    var siteCode : String!
    var staffCode : String!
    var startDate : String!
    var title : String!
    var userID : String!
    var siteName: String!
    var scheduleTypeName: String!
    var typeCodeColor: String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        typeCodeColor = dictionary["typeCodeColor"] as? String
        comments = dictionary["comments"] as? String
        endDate = dictionary["endDate"] as? String
        managerID = dictionary["managerID"] as? String
        scheduleID = dictionary["scheduleID"] as? String
        scheduleType = dictionary["scheduleType"] as? String
        siteCode = dictionary["siteCode"] as? String
        staffCode = dictionary["staffCode"] as? String
        startDate = dictionary["startDate"] as? String
        title = dictionary["title"] as? String
        userID = dictionary["userID"] as? String
        siteName = dictionary["siteName"] as? String
        scheduleTypeName = dictionary["scheduleTypeName"] as? String
    }
    
}
//{"scheduleID":"5626","userID":"william","managerID":"WILLIAM","staffCode":"100091","scheduleType":"100010","title":null,"siteCode":"SL01","startDate":"2000/05/05","endDate":"2000/05/05","comments":"","siteName":"OUTLET A"}
