//
//  DepartmentList.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 29/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class DepartmentList {
    var departmentName: String?
    var departmentCode: String?
    var departmentPic: String?
    var isSelected = false
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
      departmentName = dictionary["departmentName"] as? String
      departmentCode = dictionary["departmentCode"] as? String
      departmentPic = dictionary["departmentPic"] as? String
    }
}
