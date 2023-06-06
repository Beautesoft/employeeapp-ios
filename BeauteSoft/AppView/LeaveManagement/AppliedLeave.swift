//
//  AppliedLeave.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 31/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

//
//    Result.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AppliedLeave{
    
    var applicationID : String!
    var attachedFile : String!
    var branchName : String!
    var dayDetail : String!
    var endDate : String!
    var leaveApply : String!
    var leaveType : String!
    var managerComments : String!
    var message : String!
    var noOfDays : String!
    var profPic : String!
    var staffComments : String!
    var staffName : String!
    var startDate : String!
    var status : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        applicationID = dictionary["applicationID"] as? String
        attachedFile = dictionary["attachedFile"] as? String
        branchName = dictionary["branchName"] as? String
        dayDetail = dictionary["dayDetail"] as? String
        endDate = dictionary["endDate"] as? String
        leaveApply = dictionary["leaveApply"] as? String
        leaveType = dictionary["leaveType"] as? String
        managerComments = dictionary["managerComments"] as? String
        message = dictionary["message"] as? String
        noOfDays = dictionary["noOfDays"] as? String
        profPic = dictionary["profPic"] as? String
        staffComments = dictionary["staffComments"] as? String
        staffName = dictionary["staffName"] as? String
        startDate = dictionary["startDate"] as? String
        status = dictionary["status"] as? String
    }
}
