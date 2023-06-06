//
//  CustomerList.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 15/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//


import Foundation

class CustomerList{
    
    var customerCode : String!
    var customerName : String!
    var phoneNumber : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        customerCode = dictionary["customerCode"] as? String
        customerName = dictionary["customerName"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
    }
    
}
