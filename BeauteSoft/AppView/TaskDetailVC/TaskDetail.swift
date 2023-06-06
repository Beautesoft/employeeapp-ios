//
//  TaskDetail.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 01/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation

class TaskDetail{
    
    var amount : String!
    var appointmentDate : String!
    var appointmentEndTime : String!
    var appointmentStartTime : String!
    var attachment : String!
    var bankInFromDate : String!
    var bankInToDate : String!
    var changedOutlet : String!
    var comments : Comment!
    var currentOutlet : String!
    var customerCode : String!
    var customerName : String!
    var departmentID : String!
    var isRequestTherapist : Bool!
    var manager : Manager!
    var meritPoint : String!
    var priority : String!
    var profilePic : String!
    var queries : String!
    var remarks : String!
    var serviceIDs : String!
    var staffCode : String!
    var staffName : String!
    var status : String!
    var taskDescription : String!
    var taskID : String!
    var taskTitle : String!
    var taskType : String!
    var userID : String!
    var siteName: String!
    var siteCode: String!
    var departmentName: String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        departmentName = dictionary["departmentName"] as? String
        siteCode = dictionary["siteCode"] as? String
        siteName = dictionary["siteName"] as? String
        amount = dictionary["amount"] as? String
        appointmentDate = dictionary["appointmentDate"] as? String
        appointmentEndTime = dictionary["appointmentEndTime"] as? String
        appointmentStartTime = dictionary["appointmentStartTime"] as? String
        attachment = dictionary["attachment"] as? String
        bankInFromDate = dictionary["bankInFromDate"] as? String
        bankInToDate = dictionary["bankInToDate"] as? String
        changedOutlet = dictionary["changedOutlet"] as? String
        if let commentsData = dictionary["comments"] as? [String:Any]{
            comments = Comment(fromDictionary: commentsData)
        }
        currentOutlet = dictionary["currentOutlet"] as? String
        customerCode = dictionary["customerCode"] as? String
        customerName = dictionary["customerName"] as? String
        departmentID = dictionary["departmentID"] as? String
        isRequestTherapist = dictionary["isRequestTherapist"] as? Bool
        if let managerData = dictionary["manager"] as? [String:Any]{
            manager = Manager(fromDictionary: managerData)
        }
        meritPoint = dictionary["meritPoint"] as? String
        priority = dictionary["priority"] as? String
        profilePic = dictionary["profilePic"] as? String
        queries = dictionary["queries"] as? String
        remarks = dictionary["remarks"] as? String
        serviceIDs = dictionary["serviceIDs"] as? String
        staffCode = dictionary["staffCode"] as? String
        staffName = dictionary["staffName"] as? String
        status = dictionary["status"] as? String
        taskDescription = dictionary["taskDescription"] as? String
        taskID = dictionary["taskID"] as? String
        taskTitle = dictionary["taskTitle"] as? String
        taskType = (dictionary["taskType"] as? String)?.capitalized
        userID = dictionary["userID"] as? String
    }
}
class Manager{
    
    var branchName : String!
    var managerAttachment : String!
    var managerComment : String!
    var managerID : String!
    var managerName : String!
    var profilePic : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        branchName = dictionary["branchName"] as? String
        managerAttachment = dictionary["managerAttachment"] as? String
        managerComment = dictionary["managerComment"] as? String
        managerID = dictionary["managerID"] as? String
        managerName = dictionary["managerName"] as? String
        profilePic = dictionary["profilePic"] as? String
    }
    
}


class Comment{
    
    var comments : String!
    var userID : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        comments = dictionary["comments"] as? String
        userID = dictionary["userID"] as? String
    }
    
}
