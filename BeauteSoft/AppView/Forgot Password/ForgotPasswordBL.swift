//
//  ForgotPasswordBL.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class ForgotPasswordBL {
    func forgotPassword(params: [String: Any], _ completion : @escaping ()->()) {
        WebService.shared.postDataFor(api: base + Apis.forgotPassword, parameters: params as [String : AnyObject]) { (success, response, message) in
            if success {
                completion()
            }
        }
    }
}
