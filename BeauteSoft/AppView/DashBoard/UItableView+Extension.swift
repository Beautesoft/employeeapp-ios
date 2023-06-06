//
//  UItableView+Extension.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 05/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
import UIKit
enum TableViewSection: Int {
    case treatmentSalesCommissionHeader
    case treatmentSalesCommission
    case productSalesCommissionHeader
    case productSalesCommission
    case headCountCommisionHeader
    case headCountCommision
    case totalCommisionGetHeader
    case totalCommisionGet
    case quarterlyIncentiveHeader
    case quarterlyIncentive
    case cashVoucherHeader
    case cashVoucherSectionDetail
    case cashVoucherExpire
    case count
}

extension DashboardVC: UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.count.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableViewSection.treatmentSalesCommission.rawValue:
            return dashboard.treatmentSalesCommission.count
        case TableViewSection.productSalesCommission.rawValue:
            return dashboard.productSalesCommission.count
        case TableViewSection.headCountCommision.rawValue:
            return dashboard.headCountCommission.count 
        case TableViewSection.totalCommisionGet.rawValue:
            return dashboard.totalCommission.count
        case TableViewSection.quarterlyIncentive.rawValue:
            return dashboard.quarterlyIncentive.count
        case TableViewSection.cashVoucherSectionDetail.rawValue:
            return dashboard.cashVouchers.count
        case TableViewSection.cashVoucherExpire.rawValue:
            return 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section{
        case TableViewSection.treatmentSalesCommission.rawValue:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: DashboardDetailTVC.identifier, for: indexPath) as! DashboardDetailTVC
            let model = dashboard.treatmentSalesCommission[indexPath.row]
            let value = String(format: "%.2f", model.value.doubleValue )
            cell3.lblInfo.text = "\(model.title ?? ""): \(value)"
            cell = cell3
            break
        case TableViewSection.productSalesCommission.rawValue:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: DashboardDetailTVC.identifier, for: indexPath) as! DashboardDetailTVC
            let model = dashboard.productSalesCommission[indexPath.row]
            let value = String(format: "%.2f", model.value.doubleValue)
            cell1.lblInfo.text = "\(model.title ?? ""): \(value)"
            cell = cell1
            break
        case TableViewSection.headCountCommision.rawValue:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: DashboardDetailTVC.identifier, for: indexPath) as! DashboardDetailTVC
            let model = dashboard.headCountCommission[indexPath.row]
            let value = String(format: "%.2f", model.value.doubleValue)
            cell1.lblInfo.text = "\(model.title ?? ""): \(value)"
            cell = cell1
            break
        case TableViewSection.totalCommisionGet.rawValue:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: DashboardDetailTVC.identifier, for: indexPath) as! DashboardDetailTVC
            let model = dashboard.totalCommission[indexPath.row]
            let value = String(format: "%.2f", model.value.doubleValue)
            cell1.lblInfo.text = "\(model.title ?? ""): \(value)"
           // myButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            cell = cell1
            break
        case TableViewSection.quarterlyIncentive.rawValue:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: DashboardDetailTVC.identifier, for: indexPath) as! DashboardDetailTVC
            let model = dashboard.quarterlyIncentive[indexPath.row]
            let value = String(format: "%.2f", model.value.doubleValue)
            cell1.lblInfo.text = "\(model.title ?? ""): \(value)"
            cell = cell1
            break
        case TableViewSection.cashVoucherSectionDetail.rawValue:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: CashVoucherDetailTVC.identifier, for: indexPath) as! CashVoucherDetailTVC
            let cashVoucher = dashboard.cashVouchers[indexPath.row]
            let value = String(format: "%.2f", cashVoucher.value.doubleValue)
            cell2.lblVoucherPrice.text = "CASH VOUCHER \(cashVoucher.title.uppercased() ): \(value)"
            cell2.item = dashboard.cashVouchers[indexPath.row]
            cell2.year = cashVoucher.year ?? ""
            cell2.month = cashVoucher.title ?? ""
            cell = cell2
            break
        case TableViewSection.cashVoucherExpire.rawValue:
            let cell5 = tableView.dequeueReusableCell(withIdentifier: CashVoucherExpireTVC.identifier, for: indexPath) as! CashVoucherExpireTVC
            let expired = String(format: "%.2f", dashboard.cashVoucherExprired ?? "")
            let used = String(format: "%.2f", dashboard.cashVoucherUsed ?? "")
            cell5.lblExpired.text = expired
            cell5.lblVoucherUsed.text = used
            cell = cell5
            break
            
        case TableViewSection.treatmentSalesCommissionHeader.rawValue:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: DashboardSectionHeader.identifier, for: indexPath) as! DashboardSectionHeader
            cell4.lblTitle.text = Identifiers.treatmentSalesCommision.rawValue
            cell = cell4
            break
        case TableViewSection.productSalesCommissionHeader.rawValue:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: DashboardSectionHeader.identifier, for: indexPath) as! DashboardSectionHeader
            cell4.lblTitle.text = Identifiers.productSalesCommision.rawValue
            cell = cell4
            break
        case TableViewSection.headCountCommisionHeader.rawValue:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: DashboardSectionHeader.identifier, for: indexPath) as! DashboardSectionHeader
            cell4.lblTitle.text = Identifiers.headCountCommision.rawValue
            cell = cell4
            break
        case TableViewSection.totalCommisionGetHeader.rawValue:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: DashboardSectionHeader.identifier, for: indexPath) as! DashboardSectionHeader
            cell4.lblTitle.text = Identifiers.totalCommisionGet.rawValue
            cell = cell4
            break
        case TableViewSection.quarterlyIncentiveHeader.rawValue:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: DashboardSectionHeader.identifier, for: indexPath) as! DashboardSectionHeader
            cell4.lblTitle.text = Identifiers.quarterlyIncentive.rawValue
            cell = cell4
            break
        case TableViewSection.cashVoucherHeader.rawValue:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: CashVoucherHeader.identifier, for: indexPath) as! CashVoucherHeader
            cell = cell4
            break
        default:
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == TableViewSection.treatmentSalesCommissionHeader.rawValue{
            tableView.estimatedRowHeight = 35
            return UITableView.automaticDimension
        }else if indexPath.section == TableViewSection.cashVoucherSectionDetail.rawValue{
            tableView.estimatedRowHeight = 44
            return UITableView.automaticDimension
        }else if indexPath.section == TableViewSection.cashVoucherExpire.rawValue{
            tableView.estimatedRowHeight = 100
            return UITableView.automaticDimension
        }else if indexPath.section == TableViewSection.treatmentSalesCommissionHeader.rawValue || indexPath.section == TableViewSection.productSalesCommissionHeader.rawValue || indexPath.section == TableViewSection.headCountCommisionHeader.rawValue || indexPath.section == TableViewSection.totalCommisionGetHeader.rawValue || indexPath.section == TableViewSection.quarterlyIncentiveHeader.rawValue{
            tableView.estimatedRowHeight = 44
            return UITableView.automaticDimension
        }
        return 44
    }
}
