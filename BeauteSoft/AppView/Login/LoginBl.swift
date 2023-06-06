//
//  LoginBL.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 20/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
class LoginBL {
    func login(params: [String: Any], _ completion : @escaping ()->()) {
        WebService.shared.postDataFor(api: base + Apis.signIn, parameters: params as [String : AnyObject]) { (success, response, message) in
            if success {
                if let result = response["result"] as? [String: Any] {
                    profile = Profile(fromDictionary: result)
                    UserDefaultsManager.profile = result
                }
                completion()
            }
        }
    }
}
