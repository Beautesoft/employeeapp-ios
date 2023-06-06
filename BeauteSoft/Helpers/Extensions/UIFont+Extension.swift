//  UIFont+Extension.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import UIKit

enum Font {
    case appFont, appFontBold, appFontLight, appFontMedium
    
    var value: String {
        switch self {
        case .appFont: return "Roboto-Regular"
        case .appFontBold: return "Roboto-Bold"
        case .appFontLight: return "Roboto-Light"
        case .appFontMedium: return "Roboto-Medium"
        }
    }
}

extension UIFont {
    static func customFontOf(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Font.appFont.value, size: size) else {
            return systemFont(ofSize: size)
        }
        return font
    }
    
    static func customBoldFontOf(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Font.appFontBold.value, size: size) else {
            return systemFont(ofSize: size)
        }
        return font
    }
    
    static func customLightFontOf(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Font.appFontLight.value, size: size) else {
            return systemFont(ofSize: size)
        }
        return font
    }
    static func customMediumFontOf(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Font.appFontMedium.value, size: size) else {
            return systemFont(ofSize: size)
        }
        return font
    }
}

extension String {
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
//MARK:- Collection/TableView cells
extension UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
}
extension UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }
}
