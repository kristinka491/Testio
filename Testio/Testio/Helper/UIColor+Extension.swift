//
//  UIColor+Extension.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import Foundation

import SwiftUI


extension Color {
    
    static let lightGrayColor = Color.hexStringToColor(hex: "#CCCED3")
    static let textFieldBackgroundColor = Color.hexStringToColor(hex: "#f5f5f5")
    static let buttonBackgroundColor = Color.hexStringToColor(hex: "#4687FF")
    static let labelColor = Color.hexStringToColor(hex: "#666666")
    static let loaderTextColor = Color.hexStringToColor(hex: "#3C3C4399")
    
    static func hexStringToColor(hex: String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return Color(UIColor.gray)
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return Color(UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                             green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                             blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                             alpha: CGFloat(1.0)))
    }
}

