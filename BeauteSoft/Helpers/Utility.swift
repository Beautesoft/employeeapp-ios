//  Utility.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import Foundation
import UIKit
import CoreLocation

class Utility {
    static let shared = Utility()
    private init(){ }
    
    func makeCall(_ contactNumber: String) {
        let convert_mobile_string = contactNumber.replacingOccurrences(of: " ", with: "")
        let url:URL = URL(string: "tel://\(convert_mobile_string)")!
        if(UIApplication.shared.canOpenURL(url)) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                })
            } else {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                } else {
                    print("Call not sent")
                }
            }
        } else {
            print("Call not sent")
        }
    }
    //convert array into string
     func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func getSiteListingParameter(siteListingOption: [SiteListingOption]? = nil, siteListing: [SiteListing]? = nil, appoinmentListing: [GetAppointmentGroupList]? = nil ) -> [[String:Any]] {
        if let arrSiteListing = siteListing {
          return arrSiteListing.map{["siteCode": ($0).siteCode ?? ""]}
        }else if let arrSiteListingOpion = siteListingOption {
            return arrSiteListingOpion.map{["siteCode": ($0).itemCode ?? ""]}
        }else if let arrAppoinmentListing = appoinmentListing {
            return arrAppoinmentListing.map{["groupCode": ($0).groupCode ?? ""]}
        }
        return [[String:Any]]()
    }
    
    func getCurrentDateAndTime(format:String) -> String {
        let dateFormatter = DateFormatter()
      //  dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = format
        let now = dateFormatter.string(from: NSDate() as Date)
        return now
    }
    func formattedStringFromGivenDate( fromFormat: String, toFormat: String, dateString:String) -> String{
        //Convert string to date
        let dateFormatter = DateFormatter()
        // dateFormatter.dateFormat = "MM-dd-yyyy"
        //  dateFormatter.locale = NSLocale.autoupdatingCurrent
     //   dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = fromFormat
        
        let dateObj = dateFormatter.date(from: dateString)
        //Convert date to string
        //   print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = NSTimeZone.local
        var dateStr = ""
        if dateObj != nil{
            dateStr = dateFormatter.string(from: dateObj!)
        }
        return dateStr
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func comparisonBetweenTwoDates(startTime: String, endTime: String) -> Bool {
        let formatter = DateFormatter()
       // 27/07/2019 02:24
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        let firstDate = formatter.date(from: startTime)
        let secondDate = formatter.date(from: endTime)

        if firstDate?.compare(secondDate!) == .orderedDescending {
           return true
        }else if firstDate?.compare(secondDate!) == .orderedSame {
            return true
        }
        return false
    }
}

