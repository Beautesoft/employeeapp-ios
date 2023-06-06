//
//  SeeAttachmentVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 14/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit
import WebKit
class SeeAttachmentVC: UIViewController,WKNavigationDelegate {
   
    @IBOutlet weak var viewStaffRemark: UIView!
    @IBOutlet weak var viewStaffComment: UIView!
    @IBOutlet weak var viewManagerComment: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var LblQuery: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    
   // @IBOutlet weak var webKit: WKWebView!
    var url: String?
    var webView : WKWebView!
    var taskDetail: TaskDetail?
    var screenComesFromManager = false
    override func viewDidLoad() {
        lblComment.text = "Manager Comment: \(taskDetail?.manager.managerComment ?? "")"
        lblRemark.text = "Remark : \(taskDetail?.remarks ?? "")"
        LblQuery.text = "Query : \(taskDetail?.queries ?? "")"
        viewStaffRemark.isHidden = true
        viewStaffComment.isHidden = true
        viewManagerComment.isHidden = true
        if screenComesFromManager {
            viewManagerComment.isHidden = false
        } else {
            viewStaffRemark.isHidden = false
            viewStaffComment.isHidden = false
        }
        
        if let url = NSURL(string: url ?? "") {
            let request = URLRequest(url: url as URL)
            webView = WKWebView(frame: CGRect(x: 0, y: 0, width: viewImage.frame.width, height: viewImage.frame.height))
            webView.navigationDelegate = self
            webView.load(request)
            self.viewImage.addSubview(webView)
            self.viewImage.sendSubviewToBack(webView)
        }
        // init and load request in webview.
    }
    @IBAction func actionBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    //MARK: UIWebKit delegates
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Indicator.shared.hide()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Indicator.shared.show()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Indicator.shared.hide()
    }
}
