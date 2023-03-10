//
//  TabBarController.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 06/03/23.
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
            createNavController(for: BluetoothViewController(), title: "Home", image: UIImage(systemName: "house.fill")!),
            createNavController(for: StoreVC(), title: "Shop" , image: UIImage(systemName: "bag.circle")!),
        ]
    }
    
    
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            return navController
        }

   

}
