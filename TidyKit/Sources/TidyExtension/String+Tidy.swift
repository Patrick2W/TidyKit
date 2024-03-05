//
//  String+TidyExts.swift
//  TidyExtension
//
//  Created by wh on 2024/3/5.
//

import UIKit
import CommonCrypto


public extension TidyExtensionWrapper where Base == String {
    
    var trimming: String {
        base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func size(
        font: UIFont,
        maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
        options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin],
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        lineSpace: CGFloat? = nil
    ) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        if let lineSpace = lineSpace {
            paragraphStyle.lineSpacing = lineSpace
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSAttributedString(string: base, attributes: attributes)
        return attributedString.boundingRect(with: maxSize, options: options, context: nil).size
    }
}
