//
//  enums.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation

/// Defines the role of user
enum Role: Int {
    case manager
    case staff
}

enum ViewTypes: String {
    case assignedToMe
    case createdByMe
}


enum Pages: Int {
    case terms
    case privacyPolicy
    case help
}
enum ReportsSection: Int {
    case sale
    case td
    case leave
    case outletSale
    case count
}
enum TaskCreationSection: Int {
    case taskType
    case customerName
    case taskTitle
    case taskDescription
    case date
    case startTime
    case endDate
    case endTime
    case department
    case staffName
    case requestTherapist
    case prority
    case bankInAmountFromDate
    case bankInAmountToDate
    case branchName
    case currentOutlet
    case changeOutlet
    case amount
    case selectFiles
    case submitButton
    case count
}

enum TaskTypes: String {
    case appointment = "appointment"
    case bankIn = "bank in"
    case external = "external"
    case outletRequest = "outlet-request"
    case walkIn = "walk in"
    
    var value: String {
        switch self {
        case .appointment:
            return "Appointment"
        case .bankIn:
            return "Bank in"
        case .external:
            return "External"
        case .outletRequest:
            return "Outlet Request"
        case .walkIn:
            return "Walk in"
        }
    }
}
enum TaskTypesFilter: String {
    case all = ""
    case appointment = "appointment"
    case bankIn = "bank in"
    case external = "external"
    case outletRequest = "outlet-request"
    case walkIn = "walk in"
    
    var value: String {
        switch self {
        case .appointment:
            return "Appointment"
        case .bankIn:
            return "Bank in"
        case .external:
            return "External"
        case .outletRequest:
            return "Outlet Request"
        case .walkIn:
            return "Walk in"
        case .all:
             return "All"
        }
    }
}

enum TaskStatus: String {
    case accepted = "Accepted"
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case pending = "Pending"
    case open = "Open"
    case deleted = "Deleted"
    var intValue: Int{
        switch self {
        case .open:
            return 0
        case .accepted:
            return 1
        case .cancelled:
            return 2
        case .completed:
            return 3
        case .confirmed:
            return 4
        case .pending:
            return 5
        case .deleted:
            return 6
    }
  }
}

enum ViewType: String {
    
    case assignedToMe = "Assigned To Me"
    case createdByMe = "Created By Me"

    var value: String{
        switch self {
        case .assignedToMe:
            return "AssignedToMe"
        case .createdByMe:
            return "CreatedByMe"
        }
    }
}
enum StaffMemberTaskDetailSections: Int {
    case taskInfo
    case status
    case staffInfo
    case taskActions
    case taskCompleted
    case count
}
enum UpdateEmployeementInfo: Int {
    case employeeImage
    case customerName
    case taskTitle
    case taskDescription
    case date
    case startTime
    case endDate
    case endTime
    case department
    case staffName
    case requestTherapist
    case prority
    case bankInAmountFromDate
    case bankInAmountToDate
    case amount
    case branchName
    case currentOutlet
    case changeOutlet
    case selectFiles
    case submitButton
    case count
}
enum LeaveCategory: Int {
    case newReceived
    case approved
    case rejected
}
enum LeaveState: String {
    case Reject
    case Approved
    case Pending
}

