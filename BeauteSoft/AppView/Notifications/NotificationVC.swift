//
//  NotificationVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/7/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class NotificationCell:UITableViewCell{
    @IBOutlet var notificationImgView: UIImageView!
    @IBOutlet var notificationSubTitleLbl: UILabel!
    @IBOutlet var notificationTitleLbl: UILabel!
}

class NotificationVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    
    var getNotificationArr = [Notification]()
    override func viewDidLoad() {
        super.viewDidLoad()
getNotificationList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get notification list
    func getNotificationList(){
        
        let parameter = ["siteCode": profile.siteCode ?? ""] as [String : AnyObject]
        WebService.shared.postDataFor(api: base + Apis.getNotificationList, parameters: parameter) { (success, response, message) in
            if success {
                if let result = response["result"] as? [[String:Any]]{
                    self.getNotificationArr.removeAll()
                    result.forEach({ (dictionary) in
                        let notification = Notification(fromDictionary: dictionary)
                        self.getNotificationArr.append(notification)
                    })
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.selectionStyle = .none
        let item = getNotificationArr[indexPath.row]
        cell.notificationTitleLbl.text = item.userID ?? ""
        cell.notificationSubTitleLbl.text = item.message ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNotificationArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
}
