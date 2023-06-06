//
//  Profile.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class Profile {
    
    var siteListing : [SiteListing]!
    var clientName : String?
    var companyName : String?
    var contact : String?
    var country : String?
    var currency : String?
    var email : String?
    var empLevelCode: String?
    var empLevelDesc: String?
    var firstName : String?
    var fullName : String?
    var lastName : String?
    var location : String?
    var memberFrom : String?
    var name : String?
    var phoneNumber: String?
    var profilePic : String?
    var role : Role?
    var siteCode : String?
    var staffCode : String?
    var userID : String?
    
    var clientLogo: String?
    var HQsiteCode: String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init() {}
    
    init(fromDictionary dictionary: [String:Any]){
        siteListing = [SiteListing]()
        if let siteListingArray = dictionary["SiteListing"] as? [[String:Any]]{
            for dic in siteListingArray{
                let value = SiteListing(fromDictionary: dic)
                siteListing.append(value)
            }
        }
        clientName = dictionary["clientName"] as? String
        companyName = dictionary["companyName"] as? String
        contact = dictionary["contact"] as? String
        country = dictionary["country"] as? String
        currency = dictionary["currency"] as? String
        email = dictionary["email"] as? String
        firstName = (dictionary["firstName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        fullName = dictionary["fullName"] as? String
        lastName = (dictionary["lastName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        location = dictionary["location"] as? String
        memberFrom = dictionary["memberFrom"] as? String
        name = dictionary["name"] as? String
        profilePic = dictionary["profilePic"] as? String
        if let role = dictionary["role"] as? String, let intValue = Int(role), let roleFromEnum = Role(rawValue: intValue) {
            self.role = roleFromEnum
        }
        siteCode = dictionary["siteCode"] as? String
        staffCode = dictionary["staffCode"] as? String
        userID = dictionary["userID"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
        clientLogo = dictionary["clientLogo"] as? String
        HQsiteCode = dictionary["HQsiteCode"] as? String
        empLevelCode = dictionary["empLevelCode"] as? String
        empLevelDesc = dictionary["empLevelDesc"] as? String
    }
    
}
class SiteListing{
    
    var siteCode : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        siteCode = dictionary["siteCode"] as? String
    }
    
}
