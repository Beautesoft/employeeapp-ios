//
//  ServiceType.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 29/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class ServiceType {
    var stockName : String?
    var stockCode : String?
    var isSelected = false
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let temp = dictionary["stockName"] as? String{
            self.stockName = temp
        }
        if let temp = dictionary["stockCode"] as? String{
            self.stockCode = temp
        }
    }
}
