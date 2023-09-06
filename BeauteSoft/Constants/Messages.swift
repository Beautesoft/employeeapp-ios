//  Messages.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import Foundation
enum Messages {
    case custom(String)
    case allRequired
    case mandatory
    case passwordValidation
    case invalidEmail
    case loginSuccess
    case emailExists
    case enterPass
    case passNotMatch
    case enterFirstName
    case enterLastName
    case uploadPhoto
    case noFbEmail
    case emailPlease
    case verifyMail
    case internetError
    case cameraSupport
    case serverError
    case ok, cancel, settings
    case updateApp
    case apply
    case pleaseSelect
    case camera
    case photos
    case wentWrong
    case noInternet
    case noLocation
    case activateLocation
    case chooseOption
    //Welcome
    case enter
    case register
    //Login
    case back
    case login
    case registerWithFB
    case email
    case password
    case emailHint
    case passwordHint
    case forgotPassword
    case enterWithEmail
    //Register
    case emailRegisterHint
    case name
    case nameHint
    case confirmEmail
    case confirmEmailHint
    case passwordRegisterHint
    case confirmPassword
    case confirmPasswordHint
    case country
    case enterPhoneNumber
    case enterValidPhoneNumber
    
    //MARK:-Drawer
    case news
    case payment
    case promotions
    case history
    case share
    case help
    case termsOfUse
    case configurations
    case logoff
    case logoffMessage
    case version
    case poweredBy
    case enterLocale
    case passwordSent
    case chooseFromDate
    case chooseToDate
    case deactivatedMember
    case chooseOutlet
    case profileUpdated
    case firebaseRetrieveBaseURLError
    var value: String {
        switch self {
        case .custom(let message) : return message
        case .allRequired:
            return "All are required"
        case .chooseOption:
            return "Choose an option"
        case .camera:
            return "Camera"
        case .photos:
            return "Photos"
        case .ok:
            return "Ok"
        case.cancel:
            return "Cancel"
        case .settings:
            return "Settings"
        case .emailPlease:
            return "Please enter email"
        case .enterPass:
            return "Please enter password"
        case .enterLocale:
            return "Please enter locale"
        case .passwordSent:
            return "Password has been sent to your email"
        case .logoffMessage:
            return "Are you sure you want to logout from this application?"
        case .chooseFromDate:
            return "Please Choose From date"
        case .chooseToDate:
            return "Please Choose To date"
        case .deactivatedMember:
            return "Staff member has been deactivated"
        case .chooseOutlet:
            return "Please select atleast one service"
        case .profileUpdated:
            return "Profile has been updated sucessfully"
        case .enterFirstName:
            return "Please enter first name"
        case .enterLastName:
            return "Please enter last name"
        case .firebaseRetrieveBaseURLError:
            return "Unable to retrieve base URL."
        case .internetError: return "No internet connection"
        default:
            return ""
        }
    }
}
