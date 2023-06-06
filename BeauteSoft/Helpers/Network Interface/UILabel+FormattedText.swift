//
//  UILabel+FormattedText.swift
//  UILabel+FormattedText
//
//  Created by João Costa on 16/09/15.
//
//

import Foundation
import UIKit

extension UILabel {
    
    func fullRange() -> NSRange {
        return NSMakeRange(0, (text ?? "").count)
    }

    // MARK: Range Formatter
    
    func setTextColor(color: UIColor, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText = text
    }
    
    func setFont(font: UIFont, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributedText = text
    }
    
    func setTextUnderline(color: UIColor, range: NSRange?) {
        setTextUnderline(color: color, range: range, byWord: false)
    }

    func setTextUnderline(color: UIColor, range: NSRange?, byWord: Bool) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        var style = NSUnderlineStyle.single.rawValue
		if byWord { style = style | NSUnderlineStyle.byWord.rawValue }
        text.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: style), range: range)
        text.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
        attributedText = text
    }
    
	func setTextWithoutUnderline(range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.removeAttribute(NSAttributedString.Key.underlineStyle, range: range)
        attributedText = text
    }
    
    // MARK: String Formatter
    
    func rangeOf(string: String) -> NSRange? {
		let range = NSString(string: text ?? "").range(of: string)
        return range.location != NSNotFound ? range : nil
    }
    
    func setTextColor(color: UIColor, string: String) {
		setTextColor(color: color, range: rangeOf(string: string))
    }
    
    func setFont(font: UIFont, string: String) {
		setFont(font: font, range: rangeOf(string: string))
    }
    
    func setTextUnderline(color: UIColor, string: String) {
		setTextUnderline(color: color, range: rangeOf(string: string))
    }
    
    func setTextUnderline(color: UIColor, string: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeOf(string: string), byWord: byWord)
    }
    
	func setTextWithoutUnderline(string: String) {
		setTextWithoutUnderline(range: rangeOf(string: string))
    }
    
    // MARK: After Formatter
    
    func rangeAfter(string: String) -> NSRange? {
		guard var range = rangeOf(string: string) else { return nil }
        
        range.location = range.location + range.length
        range.length = text!.count - range.location
        return range
    }
    
    func setTextColor(color: UIColor, after: String) {
		setTextColor(color: color, range: rangeAfter(string: after))
    }
    
    func setFont(font: UIFont, after: String) {
		setFont(font: font, range: rangeAfter(string: after))
    }
    
    func setTextUnderline(color: UIColor, after: String) {
		setTextUnderline(color: color, range: rangeAfter(string: after))
    }
    
    func setTextUnderline(color: UIColor, after: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeAfter(string: after), byWord: byWord)
    }
    
	func setTextWithoutUnderline(after: String) {
		setTextWithoutUnderline(range: rangeAfter(string: after))
    }
    
    // MARK: Before Formatter
    
    func rangeBefore(string: String) -> NSRange? {
		guard var range = rangeOf(string: string) else { return nil }
        
        range.length = range.location
        range.location = 0
        return range
    }
    
    func setTextColor(color: UIColor, before: String) {
		setTextColor(color: color, range: rangeBefore(string: before))
    }
    
    func setFont(font: UIFont, before: String) {
		setFont(font: font, range: rangeBefore(string: before))
    }
    
    func setTextUnderline(color: UIColor, before: String) {
		setTextUnderline(color:color, range: rangeBefore(string: before))
    }
    
    func setTextUnderline(color: UIColor, before: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeBefore(string: before), byWord: byWord)
    }
    
	func setTextWithoutUnderline(before: String) {
		setTextWithoutUnderline(range: rangeBefore(string: before))
    }
    
    // MARK: After & Before Formatter
    
    func rangeAfter(after: String, before: String) -> NSRange? {
		guard let rAfter = rangeAfter(string: after) else { return nil }
		guard let rBefore = rangeBefore(string: before) else { return nil }
        
        if rAfter.location < rBefore.length {
            return NSMakeRange(rAfter.location, rBefore.length - rAfter.location)
        }
        
        return nil
    }
    
    func setTextColor(color: UIColor, after: String, before: String) {
		setTextColor(color: color, range: rangeAfter(after: after, before: before))
    }
    
    func setFont(font: UIFont, after: String, before: String) {
		setFont(font: font, range: rangeAfter(after: after, before: before))
    }
    
    func setTextUnderline(color: UIColor, after: String, before: String) {
		setTextUnderline(color: color, range: rangeAfter(after: after, before: before))
    }
    
    func setTextUnderline(color: UIColor, after: String, before: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeAfter(after: after, before: before), byWord: byWord)
    }
    
	func setTextWithoutUnderline(after: String, before: String) {
		setTextWithoutUnderline(range: rangeAfter(after: after, before: before))
    }
    
    // MARK: From Formatter
    
    func rangeFrom(string: String) -> NSRange? {
		guard var range = rangeOf(string: string) else { return nil }
        
        range.length = text!.count - range.location
        return range
    }
    
    func setTextColor(color: UIColor, from: String) {
		setTextColor(color: color, range: rangeFrom(string: from))
    }
    
    func setFont(font: UIFont, from: String) {
		setFont(font: font, range: rangeFrom(string: from))
    }
    
    func setTextUnderline(color: UIColor, from: String) {
		setTextUnderline(color: color, range: rangeFrom(string: from))
    }
    
    func setTextUnderline(color: UIColor, from: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeFrom(string: from), byWord: byWord)
    }
    
	func setTextWithoutUnderline(from: String) {
		setTextWithoutUnderline(range: rangeFrom(string: from))
    }
    
    // MARK: To Formatter
    
    func rangeTo(string: String) -> NSRange? {
		guard var range = rangeOf(string: string) else { return nil }
        
        range.length = range.location + range.length
        range.location = 0
        return range
    }
    
    func setTextColor(color: UIColor, to: String) {
		setTextColor(color: color, range: rangeTo(string: to))
    }
    
    func setFont(font: UIFont, to: String) {
		setFont(font: font, range: rangeTo(string: to))
    }
    
    func setTextUnderline(color: UIColor, to: String) {
		setTextUnderline(color: color, range: rangeTo(string: to))
    }
    
    func setTextUnderline(color: UIColor, to: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeTo(string: to), byWord: byWord)
    }
    
	func setTextWithoutUnderline(to: String) {
		setTextWithoutUnderline(range: rangeTo(string: to))
    }
    
    // MARK: From & To Formatter
    
    func rangeFrom(from: String, to: String) -> NSRange? {
		guard let rFrom = rangeFrom(string: from) else { return nil }
		guard let rTo = rangeTo(string: to) else { return nil }
        
        if rFrom.location < rTo.length {
            return NSMakeRange(rFrom.location, rTo.length - rFrom.location)
        }
        
        return nil
    }
    
    func setTextColor(color: UIColor, from: String, to: String) {
		setTextColor(color: color, range: rangeFrom(from: from, to: to))
    }
    
    func setFont(font: UIFont, from: String, to: String) {
		setFont(font: font, range: rangeFrom(from: from, to: to))
    }
    
    func setTextUnderline(color: UIColor, from: String, to: String) {
		setTextUnderline(color: color, range: rangeFrom(from: from, to: to))
    }
    
    func setTextUnderline(color: UIColor, from: String, to: String, byWord: Bool) {
		setTextUnderline(color: color, range: rangeFrom(from: from, to: to), byWord: byWord)
    }
    
	func setTextWithoutUnderline(from: String, to: String) {
		setTextWithoutUnderline(range: rangeFrom(from: from, to: to))
    }

    // MARK: Helpers
    
    private func mutableAttributedString() -> NSMutableAttributedString {
        if attributedText != nil {
            return NSMutableAttributedString(attributedString: attributedText!)
        } else {
            return NSMutableAttributedString(string: text ?? "")
        }
    }
}
