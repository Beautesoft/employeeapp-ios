//  TextField+Methods.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import UIKit

extension UITextField {
    var isBlank: Bool {
        return (self.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var trimmedText: String {
        return (self.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        } set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setRightAccessory(image: UIImage) {
        let accessory = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        accessory.image = image
        self.rightViewMode = .always
        self.rightView = accessory
    }
}
