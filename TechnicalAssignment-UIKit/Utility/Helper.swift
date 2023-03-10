//
//  Helper.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 10/03/23.
//

import UIKit

enum UIHelper {
    
    static func createVerticalFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    static func createHorizontalFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
}
