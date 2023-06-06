//  UIButton+Extension.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import Foundation
import UIKit
extension UIButton {
    func setTitle(_ title: Messages, state: UIControl.State = .normal) {
        self.setTitle(title.value, for: state)
    }
}
extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
}
