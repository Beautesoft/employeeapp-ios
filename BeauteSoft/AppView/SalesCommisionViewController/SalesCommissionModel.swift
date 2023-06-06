import UIKit

// MARK: - SalesCommission
struct SalesCommission: Codable {
    let success: String?
    let result: SalesData?
    let error: String?
}

// MARK: - Result
struct SalesData: Codable {
    let dayDate, empCode, siteCode, siteDesc: String?
    let tdAmnt, tdCmtn, fstTdAmnt, fstTdCmtn, courseAmnt, ppAmnt, totalSalesAmnt: Double?
    let courseCmtn, singlAmnt, singlCmtn, retailAmnt, retailCmtn, ppCmtn: Double?
    let totalDayAmnt, totalDayCmtn: Double?
    let details: [Detail]?
}

// MARK: - Detail
struct Detail: Codable {
    let dayDate, empCode, invoiceNo, siteCode: String?
    let siteDesc: String?
    let invoiceDetails: [InvoiceDetail]?
}

// MARK: - InvoiceDetail
struct InvoiceDetail: Codable {
    let invoiceNo, custName, siteCode, siteDesc: String?
    let itmNo, itmDsc: String?
    let itmQty: Int?
    let itmAmnt, itmCmtn: Double?
}

struct AmountInfo {
    let amountLabel, commissionLabel, amount, commissionAmount: String
    let color: UIColor
}

