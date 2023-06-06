//
//  WorkScheduleTypes.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 04/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//


class WorkScheduleTypes{
    
    var itemCode : String!
    var itemDesc : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        itemCode = dictionary["itemCode"] as? String
        itemDesc = dictionary["itemDesc"] as? String
    }
    
}
