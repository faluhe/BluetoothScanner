//
//  TabBarController.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 08/03/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
    }
    
    
    func setupVCs() {
        tabBar.unselectedItemTintColor = .darkGray
        
        viewControllers = [
            createNavController(for: BluetoothScannerVC(), title: K.Strings.home, image: K.Images.homeIcon),
            createNavController(for: StoreVC(), title: K.Strings.shop , image: K.Images.shopIcon),
        ]
    }
    
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            return navController
        }


}
