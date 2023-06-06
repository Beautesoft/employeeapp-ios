//
//    Result.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class StaffMember{
    
    var appointment : [Appointment]!
    var siteListing : [SiteListing]!
    var address : String!
    var siteName : String?
    var allowComm : Bool!
    var allowStaffPurc : Bool!
    var attnMarkUp : Bool!
    var attribute : Bool!
    var contact : String!
    var delMasterAirc : Bool!
    var disc : Bool!
    var displayName : String!
    var dob : String!
    var email : String!
    var emerContactNo : String!
    var emerContactPerson : String!
    var empBarcode : String!
    var empEpfNo : String!
    var empPosition : String!
    var empPositionName : String!
    var empSalary : Float!
    var empSecurity : String!
    var empSocsoAmt : Float!
    var empSocsoNo : String!
    var empType : String!
    var employeeEpf : Float!
    var employerEpf : Float!
    var firstName = ""
    var foc : Bool!
    var gender : String!
    var genderName : String!
    var isActive : Bool!
    var isactive : Bool!
    var joiningDate : String!
    var lastName = ""
    var maritalName : String!
    var maritalStatus : String!
    var maxDiscount : String!
    var nationality : String!
    var nationalityName : String!
    var nric : String!
    var offDay : String!
    var password : String!
    var profilePic : String!
    var raceName : String!
    var races : String!
    var refund : Bool!
    var religion : String!
    var religionName : String!
    var sendEmail : Bool!
    var showInAppt : Bool!
    var showInSales : Bool!
    var showInTrmt : Bool!
    var siteCode : String!
    var skillset : String!
    var skillsetName : String!
    var staffCode : String!
    var target : String!
    var targetPeriod : String!
    var targetType : String!
    var userLogin : String!
    var voidTran : Bool!
    var dayEndSettlement: Bool!
    var fullName : String {
        return "\(self.firstName) \(self.lastName)"
    }
//    case discount = "Entitlement to give discount"
//    case userActive = "User is currently active"
//    case attendMakeUp = "Attendance Make Up"
//    case deleteArtical = "Delete Matser Articles"
//    case transactions = "Void Transactions"
//    case foc = "FOC"
//    case refind = "Refind"
//    case sendEmail = "Send Email"

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        appointment = [Appointment]()
        if let appointmentArray = dictionary["Appointment"] as? [[String:Any]]{
            for dic in appointmentArray{
                let value = Appointment(fromDictionary: dic)
                appointment.append(value)
            }
        }
        siteListing = [SiteListing]()
        if let siteListingArray = dictionary["SiteListing"] as? [[String:Any]]{
            for dic in siteListingArray{
                let value = SiteListing(fromDictionary: dic)
                siteListing.append(value)
            }
        }
        address = dictionary["address"] as? String
        siteName = dictionary["siteName"] as? String
        allowComm = dictionary["allowComm"] as? Bool
        allowStaffPurc = dictionary["allowStaffPurc"] as? Bool
        attnMarkUp = dictionary["attnMarkUp"] as? Bool
        attribute = dictionary["attribute"] as? Bool
        contact = dictionary["contact"] as? String
        delMasterAirc = dictionary["delMasterAirc"] as? Bool
        disc = dictionary["disc"] as? Bool
        displayName = dictionary["displayName"] as? String
        dob = dictionary["dob"] as? String
        email = dictionary["email"] as? String
        emerContactNo = dictionary["emerContactNo"] as? String
        emerContactPerson = dictionary["emerContactPerson"] as? String
        empBarcode = dictionary["empBarcode"] as? String
        empEpfNo = dictionary["empEpfNo"] as? String
        empPosition = dictionary["empPosition"] as? String
        empPositionName = dictionary["empPositionName"] as? String
        empSalary = dictionary["empSalary"] as? Float
        empSecurity = dictionary["empSecurity"] as? String
        empSocsoAmt = dictionary["empSocsoAmt"] as? Float
        empSocsoNo = dictionary["empSocsoNo"] as? String
        empType = dictionary["empType"] as? String
        employeeEpf = dictionary["employeeEpf"] as? Float
        employerEpf = dictionary["employerEpf"] as? Float
        firstName = (dictionary["firstName"] as? String ?? "").trimmed
        foc = dictionary["foc"] as? Bool
        gender = dictionary["gender"] as? String
        genderName = dictionary["genderName"] as? String
        isActive = dictionary["isActive"] as? Bool
        isactive = dictionary["isactive"] as? Bool
        joiningDate = dictionary["joiningDate"] as? String
        lastName = (dictionary["lastName"] as? String ?? "").trimmed
        maritalName = dictionary["maritalName"] as? String
        maritalStatus = dictionary["maritalStatus"] as? String
        maxDiscount = dictionary["maxDiscount"] as? String
        nationality = dictionary["nationality"] as? String
        nationalityName = dictionary["nationalityName"] as? String
        nric = dictionary["nric"] as? String
        offDay = dictionary["offDay"] as? String
        password = dictionary["password"] as? String
        profilePic = dictionary["profilePic"] as? String
        raceName = dictionary["raceName"] as? String
        races = dictionary["races"] as? String
        refund = dictionary["refund"] as? Bool
        religion = dictionary["religion"] as? String
        religionName = dictionary["religionName"] as? String
        sendEmail = dictionary["sendEmail"] as? Bool
        showInAppt = dictionary["showInAppt"] as? Bool
        showInSales = dictionary["showInSales"] as? Bool
        showInTrmt = dictionary["showInTrmt"] as? Bool
        siteCode = dictionary["siteCode"] as? String
        skillset = dictionary["skillset"] as? String
        skillsetName = dictionary["skillsetName"] as? String
        staffCode = dictionary["staffCode"] as? String
        target = dictionary["target"] as? String
        targetPeriod = dictionary["targetPeriod"] as? String
        targetType = dictionary["targetType"] as? String
        userLogin = dictionary["userLogin"] as? String
        voidTran = dictionary["voidTran"] as? Bool
        dayEndSettlement = dictionary["dayEndSettlement"] as? Bool
    }
}

class Appointment{
    var groupCode : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        groupCode = dictionary["groupCode"] as? String
    }
    
}

