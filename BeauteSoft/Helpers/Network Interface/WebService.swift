//
//  WebService.swift
//  Basic
//
//  Created by Himanshu on 02/01/18.
//  Copyright © 2018 Igniva Solutions Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

typealias WebServiceResponse = (Bool, NSDictionary, String) -> ()

class WebService {
    
    static let shared = WebService()
    fileprivate init(){}

	
	    func postDataFor(api: String, parameters: [String: AnyObject]? = nil, header: [String: String]? = nil,
	                     showIndicator: Bool? = true, responseClosure: @escaping WebServiceResponse) {
	
	        if !NetworkReachabilityManager()!.isReachable {
	            displayAlertWithSettings()
	            return
	        }
	
	        if showIndicator! {
	            Indicator.shared.show()
	        }
	
	        debugPrint("********************************* API Request **************************************")
	        debugPrint("Request URL:\(api)")
	        debugPrint("Request Parameters: \(parameters ?? [: ])")
			debugPrint("Request Headers: \(header ?? [:])")
	        debugPrint("************************************************************************************")
	
			request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
	            .responseJSON { response in
                print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                     print("Response code: -> \(response.response?.statusCode)")
	                switch response.result {
						
	                case .success(_):
	                    if let data = response.result.value as? NSDictionary {
	      						var status = String()
							if let statusCode = data["success"] as? NSNumber {
								status = "\(statusCode)"
							} else if let statusCode = data["success"] as? String {
								status = statusCode
							}
	                            if status == "1" {
	                                var message = String()
	                                if let msg = data["response_message"] as? String {
	                                    message = msg
	                                } else if let msg = data["customMessage"] as? String {
	                                    message = msg
	                                } else if let msg = data["description"] as? String {
	                                    message = msg
	                                }
	                                Indicator.shared.hide()
	                                responseClosure((status == "1"), data, message)
	                            } else {
	                                StatusHandler.handle(json: data)
	                            }
	                    }
	                case .failure(let error):
	                    StatusHandler.handle(error: error)
	                }
	        }
	    }
	
    func getDataFrom(api: String, header: [String: String]? = nil, showIndicator: Bool? = true,  responseClosure: @escaping WebServiceResponse) {
        
        if !NetworkReachabilityManager()!.isReachable {
            displayAlertWithSettings()
            return
        }
        
        if showIndicator! {
            Indicator.shared.show()
        }
		debugPrint("********************************* API Request **************************************")
        debugPrint("Request URL:\(api)")
		debugPrint("Request Headers: \(header ?? [:])")
        debugPrint("************************************************************************************")
        
        request(api, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
            print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                print("Response code: -> \(response.response?.statusCode)")
                switch response.result {
                case .success(_):
                    if let data = response.result.value as? NSDictionary {
                        if let statusCode = data["success"] as? String {
                            if statusCode == "1" || statusCode == "Success"{
                                var message = String()
                                if let msg = data["response_message"] as? String {
                                    message = msg
                                } else if let msg = data["customMessage"] as? String {
                                    message = msg
                                } else if let msg = data["error"] as? String {
                                    message = msg
                                }
                                Indicator.shared.hide()
                                responseClosure(true, data, message)
                            } else {
                                StatusHandler.handle(json: data)
                            }
                        }
                    }
                case .failure(let error):
                    StatusHandler.handle(error: error)
                }
        }
    }
    
    func uploadMediaToServer(api: String, imgMedia: [String: Data]? = nil, videoMedia:[String: Data]? = nil,
                             parameters: [String: AnyObject]? = nil, header: [String: String]? = nil,
                             showIndicator: Bool? = true, responseClosure: @escaping WebServiceResponse) {
        if !NetworkReachabilityManager()!.isReachable {
            displayAlertWithSettings()
            return
        }
        
        if showIndicator! {
            Indicator.shared.show()
        }
        
		
        
        debugPrint("********************************* API Request **************************************")
        debugPrint("Request URL:\(api)")
        debugPrint("Request Parameters: \(parameters ?? [: ])")
		debugPrint("Request Headers: \(header ?? [:])")
		debugPrint("Request Headers: \(imgMedia ?? [:])")
        debugPrint("************************************************************************************")
        
		var url = try! URLRequest.init(url: (api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.asURL())!, method: .post, headers: header)
		
        url.timeoutInterval = 180
        
        Alamofire.upload(multipartFormData: { (formdata) in
            if let params = parameters {
                for (key, value) in params {
                    formdata.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            if let images = imgMedia {
                for (key,value) in images {
                    let interval = NSDate().timeIntervalSince1970 * 1000
                    let imgMimeType : String = "image/jpeg"
                    let imgFileName = "img\(interval).jpeg"
                    formdata.append(value, withName: key, fileName: imgFileName, mimeType: imgMimeType)
                }
            }
            if let videos = videoMedia {
                for (key,value) in videos {
                    let interval = NSDate().timeIntervalSince1970 * 1000
                    let  videoMimeType = "video/mp4"
                    let  videoFileName = "vid\(interval).mp4"
                    formdata.append(value, withName: key, fileName: videoFileName, mimeType: videoMimeType)
                }
            }
        }, with: url) { (encodingResult) in
             print("Encoding result: -> \(encodingResult)")
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
						Indicator.shared.hide()
                    print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                    switch response.result{
                    case .success(_):
                        if let data = response.result.value as? NSDictionary {
							Indicator.shared.hide()
                            var status = String()
                            if let statusCode = data["success"] as? NSNumber {
                                status = "\(statusCode)"
                            } else if let statusCode = data["success"] as? String {
                                status = statusCode
                            }
                            
                            if status == "1" {
                                var message = String()
                                if let msg = data["response_message"] as? String {
                                    message = msg
                                } else if let msg = data["message"] as? String {
                                    message = msg
                                } else if let msg = data["error"] as? String {
                                    message = msg
                                }
                                
                                responseClosure(true, data, message)
                            } else {
                                StatusHandler.handle(json: data)
                            }
                        }
                    case .failure(let error):
                        StatusHandler.handle(error: error)
                    }
                })
            case .failure(let error):
                StatusHandler.handle(error: error)
            }
        }
    }
    
    func displayAlertWithSettings() {
        let topController = AppDelegate.shared.window?.rootViewController
        let methodToOpenSettings = {
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    topController?.singleButtonAlertWith(message: .internetError, button: .ok)
                    return
                }
            }
        }
        
        let okAction: AlertButtonWithAction = (.ok, nil)
        let settings: AlertButtonWithAction = (.settings, methodToOpenSettings)
        topController?.alertWith(message: .internetError, actions: settings, okAction)
    }
}
