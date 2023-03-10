//
//  CustomViews.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 08/03/23.
//

import UIKit

class TextLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    convenience init(textAlignment: NSTextAlignment = .left, font: UIFont?, fontSize: CGFloat? = nil, textColor: UIColor?, text: String = "") {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.text = text
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
    }
    
}
