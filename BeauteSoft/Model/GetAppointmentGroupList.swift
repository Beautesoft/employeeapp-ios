//
//  GetAppointmentGroupList.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 23/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class GetAppointmentGroupList {
  
    var groupCode : String!
    var groupName : String!
    var isSelected = false
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        groupCode = dictionary["groupCode"] as? String
        groupName = dictionary["groupName"] as? String
    }
}
