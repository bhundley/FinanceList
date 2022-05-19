//
//  Theme.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import UIKit

class Theme {
    public class var placeholder: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Book", size: 12)!, UIColor(named: "defaultLabel")!)
    }
    
    public class var cellPreTitle: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Roman", size: 12)!, UIColor.secondaryLabel)
    }
    
    public class var smallerSecondaryTitle: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Roman", size: 12)!, UIColor.secondaryLabel)
    }
    
    public class var cellDetail: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Roman", size: 16)!, UIColor(named: "defaultLabel")!)
    }
    
    public class var defaultLabel: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Roman", size: 16)!, UIColor(named: "defaultLabel")!)
    }
    
    public class var creditLabel: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Roman", size: 16)!, UIColor(named: "creditLabel")!)
    }
    
    public class var errorMessage: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Medium", size: 14)!, UIColor.systemRed)
    }
    
    public class var heavyLabel: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Heavy", size: 16)!, UIColor(named: "defaultLabel")!)
    }
    
    public class var buttonTitle: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Roman", size: 16)!, UIColor(named: "buttonTitle")!)
    }
    
    public class var actionSheetTitle: (font: UIFont, color: UIColor) {
        return (UIFont(name: "Avenir-Heavy", size: 20)!, UIColor(named: "defaultLabel")!)
    }
    
    public class var customSecondayBackground: UIColor {
        return UIColor(named: "secondaryBackground")!
    }
    
    public class var actionSheetTitleStyle: [NSAttributedString.Key : Any] {
        return [
            NSAttributedString.Key.font : actionSheetTitle.font,
            NSAttributedString.Key.foregroundColor : actionSheetTitle.color
        ]
    }
}
