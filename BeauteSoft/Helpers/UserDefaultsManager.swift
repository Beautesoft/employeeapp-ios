//  UserDefaultsManager.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import Foundation

class UserDefaultsManager {
    
    
    static var lattitude: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.lattitude.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.lattitude.value)
        }
    }
    static var longitude: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.longitude.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.longitude.value)
        }
    }
    static var deviceToken: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.deviceToken.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.deviceToken.value)
        }
    }
    static var userId: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.userId.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.userId.value)
        }
    }
    static var password: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.password.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.password.value)
        }
    }
    static var locale: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.locale.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.locale.value)
        }
    }
    static var profile: [String : Any]? {
        set {
//            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.profile.value)
//            UserDefaults.standard.synchronize()
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: UserDefaultConstants.profile.value)
        } get {
//            return UserDefaults.standard.dictionary(forKey: UserDefaultConstants.profile.value)
            guard let outData = UserDefaults.standard.data(forKey: UserDefaultConstants.profile.value) else { return nil}
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData) as! [String : Any]
            return dict
        }
    }
    
    
    func getLanguage(key:String) -> String{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        return jsonString
    }
    
    func getToken(key:String) -> String{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        return jsonString
    }
    
    
    
   class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key == UserDefaultConstants.profile.value || key == UserDefaultConstants.userId.value || key == UserDefaultConstants.password.value  || key == UserDefaultConstants.locale.value{
                defaults.removeObject(forKey: key)
            }
        }
       defaults.synchronize()
    }
}
