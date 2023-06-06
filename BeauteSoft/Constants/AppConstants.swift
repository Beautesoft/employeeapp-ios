//  AppConstants.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import Foundation
import UIKit

enum AppInfo {
    static let Mode = "development"
    static let AppName = "BeauteSoft"
    static let Version =  "1.0.0"
    static let appColor = UIColor(red: 231.0/255.0, green: 213.0/255.0, blue: 152.0/255.0, alpha: 1.0)
}

enum AppConstants {
    case googleApiAddress
    var value: String {
        switch self {
        case .googleApiAddress: return "https://maps.googleapis.com/maps/api/"
        }
    }
}

/*ang@sequoia-asia.com

Wvv7338M! */
