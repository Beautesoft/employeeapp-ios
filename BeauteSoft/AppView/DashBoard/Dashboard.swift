//
//  Dashboard.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 06/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

//
//    Result.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Dashboard{
    
    var cashVoucherExprired : Float!
    var cashVoucherUsed : Float!
    var cashVouchers = [CashVoucher]()
    var headCountCommission = [HeadCountCommission]()
    var productSalesCommission = [HeadCountCommission]()
    var quarterlyIncentive = [HeadCountCommission]()
    var starRating : Float!
    var totalCommission = [HeadCountCommission]()
    var treatmentSalesCommission = [HeadCountCommission]()
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    func setValue(fromDictionary dictionary: [String: AnyObject]){
        cashVoucherExprired = dictionary["cash_voucher_exprired"] as? Float
        cashVoucherUsed = dictionary["cash_voucher_used"] as? Float
        cashVouchers = [CashVoucher]()
        if let cashVouchersArray = dictionary["cash_vouchers"] as? [[String:Any]]{
            for dic in cashVouchersArray{
                let value = CashVoucher(fromDictionary: dic)
                cashVouchers.append(value)
            }
        }
        headCountCommission = [HeadCountCommission]()
        if let headCountCommissionArray = dictionary["head_count_commission"] as? [[String:Any]]{
            for dic in headCountCommissionArray{
                let value = HeadCountCommission(fromDictionary: dic)
                headCountCommission.append(value)
            }
        }
        productSalesCommission = [HeadCountCommission]()
        if let productSalesCommissionArray = dictionary["product_sales_commission"] as? [[String:Any]]{
            for dic in productSalesCommissionArray{
                let value = HeadCountCommission(fromDictionary: dic)
                productSalesCommission.append(value)
            }
        }
        quarterlyIncentive = [HeadCountCommission]()
        if let quarterlyIncentiveArray = dictionary["quarterly_incentive"] as? [[String:Any]]{
            for dic in quarterlyIncentiveArray{
                let value = HeadCountCommission(fromDictionary: dic)
                quarterlyIncentive.append(value)
            }
        }
        starRating = dictionary["starRating"] as? Float
        totalCommission = [HeadCountCommission]()
        if let totalCommissionArray = dictionary["total_commission"] as? [[String:Any]]{
            for dic in totalCommissionArray{
                let value = HeadCountCommission(fromDictionary: dic)
                totalCommission.append(value)
            }
        }
        treatmentSalesCommission = [HeadCountCommission]()
        if let treatmentSalesCommissionArray = dictionary["treatment_sales_commission"] as? [[String:Any]]{
            for dic in treatmentSalesCommissionArray{
                let value = HeadCountCommission(fromDictionary: dic)
                treatmentSalesCommission.append(value)
            }
        }
    }

}

class QuarterlyIncentive{
    
    var title : String!
    var value : NSNumber!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        value = dictionary["value"] as? NSNumber
    }
    
}
class HeadCountCommission{
    
    var title : String!
    var value : NSNumber!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        value = dictionary["value"] as? NSNumber
    }
    
}

class CashVoucher{
    
    var available : Int!
    var title : String!
    var value : NSNumber!
    var year: String?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        available = dictionary["available"] as? Int
        title = dictionary["title"] as? String
        value = dictionary["value"] as? NSNumber
        year = dictionary["year"] as? String
    }
    
}
