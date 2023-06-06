//
//  TaskList.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 28/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation

class TaskList {
    var taskTitle : String?
    var appointmentDate : String?
    var appointmentEndTime : String?
    var taskId: String?
    var taskImage: String?
    var taskDescription: String?
    var priority: String?
    var status: String?
    var taskType: String?
    var appointmentStartTime: String?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let temp = dictionary["appointmentStartTime"] as? String{
            self.appointmentStartTime = temp
        }
        if let temp = dictionary["taskType"] as? String{
            self.taskType = temp
        }

        if let temp = dictionary["taskTitle"] as? String{
           self.taskTitle = temp
        }
        if let temp = dictionary["status"] as? String{
            self.status = temp
        }
        if let temp = dictionary["priority"] as? String{
            self.priority = temp
        }
        if let temp = dictionary["appointmentDate"] as? String{
            self.appointmentDate = temp
        }
        if let temp = dictionary["appointmentEndTime"] as? String{
            self.appointmentEndTime = temp
        }
        if let temp = dictionary["taskID"] as? String{
            self.taskId = temp
        }
        if let temp = dictionary["profilePic"] as? String{
            self.taskImage = temp
        }
        if let temp = dictionary["taskDescription"] as? String{
            self.taskDescription = temp
        }
    }
}


