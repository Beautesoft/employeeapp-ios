//
//  TaskHistory.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 27/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class TaskHistory {
   
    var  customerName: String?
    var  customerPic: String?
    var  taskTitle: String?
    var  descriptionTask: String?
    var  startDate: String?
    var  startTime: String?
    var  endTime: String?
    var  isSelected = false
    
    init(fromDictionary dictionary: [String:Any]){
        customerName = dictionary["customerName"] as? String
        customerPic = dictionary["customerPic"] as? String
        taskTitle = dictionary["taskTitle"] as? String
        descriptionTask = dictionary["descriptionTask"] as? String
        startDate = dictionary["startDate"] as? String
        startTime = dictionary["startTime"] as? String
        endTime = dictionary["endTime"] as? String
    }
}
//if let title = historyDictArr[indexPath.row]["customerName"] as? String{
//    cell.customerNamelbl.text = title
//}
//let url = URL(string:historyDictArr[indexPath.row]["customerPic"] as! String)
//cell.imgView.sd_setImage(with: url , placeholderImage: nil)
//
//if let title = historyDictArr[indexPath.row]["taskTitle"] as? String{
//    cell.taskTileLbl.text = title
//}
//if let title = historyDictArr[indexPath.row]["descriptionTask"] as? String{
//    cell.descLbl.text = title
//}
//if let title = historyDictArr[indexPath.row]["startDate"] as? String{
//    cell.startDate.text = title
//}
//if let startTime = historyDictArr[indexPath.row]["startTime"] as? String{
//    if let endTime = historyDictArr[indexPath.row]["endTime"] as? String{
//        cell.startDate.text = startTime + "-" + endTime
//    }
//}
