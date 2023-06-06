//  UserDefaultConstants.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import Foundation

enum UserDefaultConstants {
    case profile
    case lattitude
    case longitude
    case deviceToken
    case userId
    case locale
    case password
    
    var value: String {
        switch self {
        case .profile: return "profile"
        case .lattitude: return "deviceLattitude"
        case .longitude: return "deviceLongitude"
        case .deviceToken: return "deviceToken"
        case .userId: return "userId"
        case .locale: return "locale"
        case .password: return "password"
            
        }
    }
}
