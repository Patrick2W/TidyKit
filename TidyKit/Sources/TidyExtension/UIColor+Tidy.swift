//
//  UIColor+TidyExts.swift
//  TidyExtension
//
//  Created by wh on 2024/3/5.
//

import UIKit

public extension TidyExtensionWrapper where Base: UIColor {
    
    static var random: UIColor {
        rgb(CGFloat(arc4random() % 255), CGFloat(arc4random() % 255), CGFloat(arc4random() % 255))
    }
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    static func hex(_ hex: UInt32) -> UIColor {
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0xFF00) >> 8
        let b = (hex & 0xFF)
        return rgb(CGFloat(r), CGFloat(g), CGFloat(b))
    }
    
    static func hexa(_ hexa: UInt32) -> UIColor {
        let r = (hexa & 0xFF000000) >> 24
        let g = (hexa & 0xFF0000) >> 16
        let b = (hexa & 0xFF00) >> 8
        let a = Float(hexa & 0xFF) / 255.0
        return rgba(CGFloat(r), CGFloat(g), CGFloat(b), CGFloat(a))
    }
    
    static func hex(_ string: String) -> UIColor {
        var cString: String = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var hexValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&hexValue)
        if (cString.count == 6) {
            return hex(hexValue)
        }
        else if cString.count == 8 {
            return hexa(hexValue)
        }
        return .white
    }
    
//    var hexStr: String {
//        var red: CGFloat = 0
//        var green: CGFloat = 0
//        var blue: CGFloat = 0
//        base.getRed(&red, green: &green, blue: &blue, alpha: nil)
//
//        let r = Int(255.0 * red)
//        let g = Int(255.0 * green)
//        let b = Int(255.0 * blue)
//
//        let str = String(format: "#%02x%02x%02x", r, g, b)
//        return str
//    }
}
