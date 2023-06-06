//
//  TaskType.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 28/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class TaskType {
    var itemCode: String?
    var itemDesc: String?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let temp = dictionary["itemCode"] as? String{
            self.itemCode = temp
        }
        if let temp = dictionary["itemDesc"] as? String{
            self.itemDesc = temp
        }
    }
}
