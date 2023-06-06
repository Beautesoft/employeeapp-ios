//
//  SiteListingOption.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 24/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation

class SiteListingOption{
    var  itemCode: String?
    var  itemDesc: String?
    var  isSelected = false
    init(fromDictionary dictionary: [String:Any]){
        itemCode = dictionary["itemCode"] as? String
        itemDesc = dictionary["itemDesc"] as? String
    }
}
