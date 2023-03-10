//
//  Color+Extension.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 08/03/23.
//

import UIKit

//MARK: - Making easy to access in to colors in the project
extension UIColor {
    static func setColor(_ name: String) -> UIColor? {
        return UIColor(named: name)
    }
    
    //can add any image name that in the project
    static let appColor: UIColor? = setColor("appColor")
    static let appGray: UIColor? = setColor("appGray")
    static let appOrange: UIColor? = setColor("appOrange")
    static let appDarkGray: UIColor? = setColor("appDarkGray")
    
    
}
