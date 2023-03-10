//
//  UILabel+Extension.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 06/03/23.
//

import UIKit

extension UILabel {
    //MARK: - Spacing between label
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
