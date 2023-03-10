//
//  StoreVC.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 06/03/23.
//

import UIKit

class StoreVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    // MARK: - Page elements
    lazy var icon: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bluetooth"))
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Searching"
        return lbl
    }()
}
