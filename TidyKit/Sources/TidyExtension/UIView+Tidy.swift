//
//  UIView+Tidy.swift
//  TidyExtension
//
//  Created by wh on 2024/3/5.
//

import UIKit

public extension TidyExtensionWrapper where Base: UIView {
    
    var frame: CGRect {
        set { base.frame = newValue }
        get { base.frame }
    }
    
    var x: CGFloat {
        set { base.frame.origin.x = newValue }
        get { base.frame.minX }
    }
    
    var y: CGFloat {
        set { base.frame.origin.y = newValue }
        get { base.frame.minY }
    }
    
    var width: CGFloat {
        set { base.frame.size.width = newValue }
        get { base.frame.width }
    }
    
    var height: CGFloat {
        set { base.frame.size.height = newValue }
        get { base.frame.height }
    }
    
    var size: CGSize {
        set { base.frame.size = newValue }
        get { base.frame.size }
    }
    
    var centerX: CGFloat {
        set { base.center = CGPoint(x: newValue, y: base.center.y) }
        get { base.center.x }
    }
    
    var centerY: CGFloat {
        set { base.center = CGPoint(x: base.center.y, y: newValue) }
        get { base.center.y }
    }
    
    var minX: CGFloat {
        set { base.frame.origin.x = newValue }
        get { base.frame.minX }
    }
    
    var midX: CGFloat {
        set { base.frame.origin.x = newValue - base.frame.size.width * 0.5 }
        get { base.frame.midX }
    }
    
    var maxX: CGFloat {
        set { base.frame.origin.x = newValue - base.frame.size.width }
        get { base.frame.maxX }
    }
    
    var minY: CGFloat {
        set { base.frame.origin.y = newValue }
        get { base.frame.minY }
    }
    
    var midY: CGFloat {
        set { base.frame.origin.y = newValue - base.frame.size.height * 0.5 }
        get { base.frame.midY }
    }
    
    var maxY: CGFloat {
        set { base.frame.origin.y = newValue - base.frame.size.height }
        get { base.frame.maxY }
    }
    
    var left: CGFloat {
        set { base.frame.origin.x = newValue }
        get { base.frame.origin.x }
    }
    
    var top: CGFloat {
        set { base.frame.origin.y = newValue }
        get { base.frame.origin.y }
    }
    
    var right: CGFloat {
        set { base.frame.origin.x = newValue - base.frame.size.width }
        get { base.frame.origin.x + base.frame.size.width }
    }
    
    var bottom: CGFloat {
        set { base.frame.origin.y = newValue - base.frame.size.height }
        get { base.frame.origin.y + base.frame.size.height }
    }
}
