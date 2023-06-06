//
//  StatusHandler.swift
//  Basic
//
//  Created by Himanshu on 02/01/18.
//  Copyright © 2018 Igniva Solutions Pvt Ltd. All rights reserved.
//

import Foundation

class StatusHandler {
    static func handle(json: NSDictionary) {
        Indicator.shared.hide()
		var code = -1
        if let tempCodeStr = json["success"] as? String, let tempCode = Int(tempCodeStr)   {
			code = tempCode
		} else if let tempCode = json["success"] as? Int {
			code = tempCode
		} 
        
        var message = String()
        if let msg = json["response_message"] as? String {
            message = msg
        } else if let msg = json["customMessage"] as? String {
            message = msg
        } else if let msg = json["error"] as? String {
            message = msg
        }
        
        switch code {
            // handling according to status goes here
        default:
            AppDelegate.shared.window?.rootViewController?.singleButtonAlertWith(message: .custom(message), button: .ok)
        }
    }
    
    static func handle(error: Error) {
        Indicator.shared.hide()
        if error.localizedDescription.contains("The Internet connection appears to be offline.") {
            // send to settings app
        } else if error.localizedDescription.contains("JSON could not be serialized because of error") {
            AppDelegate.shared.window?.rootViewController?.singleButtonAlertWith(message: .serverError, button: .ok)
        }  else {
            AppDelegate.shared.window?.rootViewController?.singleButtonAlertWith(message: .custom(error.localizedDescription), button: .ok)
        }
    }
}
