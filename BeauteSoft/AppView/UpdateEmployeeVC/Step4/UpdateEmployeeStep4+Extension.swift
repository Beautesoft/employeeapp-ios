////
////  UpdateEmployeeStep4+Extension.swift
////  BeauteSoft
////
////  Created by Ankit Pahwa on 24/05/19.
////  Copyright © 2019 Himanshu Singla. All rights reserved.
////
//
//import Foundation
//import UIKit
//enum TableViewSection : Int {
//    case SalaryHeader
//    case SalaryInformation
//    case TargetHeader
//    case TargetInformation
//    case AppoinmentHeader
//    case AppoimentInformation
//    case count
//}
////MARK: - TableView Delegate And DataSources
//extension UpdateEmployeeStepFourVC: UITableViewDelegate,UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return TableViewSection.count.rawValue
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case TableViewSection.SalaryInformation.rawValue:
//            return 6
//        case TableViewSection.TargetInformation.rawValue:
//            return 3
//        case TableViewSection.AppoimentInformation.rawValue:
//            return 1
//        default:
//            return 1
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        switch indexPath.section {
//        case TableViewSection.SalaryInformation.rawValue:
//            let cell1 = tableView.dequeueReusableCell(withIdentifier: Identifiers.SalaryInformationTVC.rawValue, for: indexPath)
//            cell = cell1
//        case TableViewSection.TargetInformation.rawValue:
//            let cell2 = tableView.dequeueReusableCell(withIdentifier: Identifiers.TargetInformationTVC.rawValue, for: indexPath)
//            cell = cell2
//            break
//        case TableViewSection.AppoimentInformation.rawValue:
//            let cell3 = tableView.dequeueReusableCell(withIdentifier: Identifiers.AppoimentInformationTVC.rawValue, for: indexPath)
//            cell = cell3
//        case TableViewSection.SalaryHeader.rawValue:
//            let headerCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.HeaderView.rawValue, for: indexPath) as! HeaderView
//            //  headerCell.lblRecommeded.text = "RECOMMENDED"
//            cell = headerCell
//        case TableViewSection.TargetHeader.rawValue:
//            let headerCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.HeaderView.rawValue, for: indexPath) as! HeaderView
//            //  headerCell.lblRecommeded.text = "RECOMMENDED"
//            cell = headerCell
//        case TableViewSection.AppoinmentHeader.rawValue:
//            let headerCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.HeaderView.rawValue, for: indexPath) as! HeaderView
//            //  headerCell.lblRecommeded.text = "RECOMMENDED"
//            cell = headerCell
//        default:
//            return cell
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == TableViewSection.SalaryInformation.rawValue || indexPath.section == TableViewSection.TargetInformation.rawValue {
//            return 65
//        }else if  indexPath.section == TableViewSection.AppoimentInformation.rawValue {
//            return 65
//        }else {
//            return 50
//        }
//    }
//}
