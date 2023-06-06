//
//    Result.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class SaloonList{
    
    var location : String?
    var displayPic : String?
    var rating : Float?
    var siteCode : String?
    var siteName : String?
    var numberOfStaffMember : String?
    var numberOfInactiveStaffs : String?
    var description: String?
    var reviews: String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        location = dictionary["Location"] as? String
        displayPic = dictionary["displayPic"] as? String
        siteCode = dictionary["siteCode"] as? String
        siteName = dictionary["siteName"] as? String
        if let temp = dictionary["rating"] as? String {
          self.rating = Float(temp)
        }else if let temp = dictionary["rating"] as? Float{
          self.rating = temp
        }
        if let temp = dictionary["NumberOfStaffMember"] as? String {
            self.numberOfStaffMember = temp
        }else if let temp = dictionary["NumberOfStaffMember"] as? Int{
            self.numberOfStaffMember = String(temp)
        }
        if let temp = dictionary["NumberOfInactiveStaffs"] as? String {
            self.numberOfInactiveStaffs = temp
        }else if let temp = dictionary["NumberOfInactiveStaffs"] as? Int{
            self.numberOfInactiveStaffs = String(temp)
        }
        description = dictionary["description"] as? String
    }
}

