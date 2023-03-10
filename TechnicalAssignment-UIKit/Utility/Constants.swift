//
//  Constants.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 10/03/23.
//

import UIKit

//MARK: - Constants

struct K{
    struct Images {
        static let homeIcon = UIImage(systemName: "house.fill")!
        static let shopIcon = UIImage(systemName: "bag.circle")!
        static let avatar = UIImage(named: "avatar")!
        static let bluetoothIcon = UIImage(named: "bluetooth")!
        static let blue_icon = UIImage(named: "icon")!
        static let disclosureIndicator = UIImage(systemName: "chevron.right")
    }
    
    struct Strings{
        //TabBar items
        static let home = "Home"
        static let shop = "Shop"

        static let searching = "SEARCHING"
        static let remeberKeepScooterNear = "Remember to keep your scooter on and within 6 feet"
        static let startScanning = "Start scanning"
        static let scootersFound = "Scooters found"
        static let seeAll = "See all"
        static let buy = "Buy"
        static let store = "Store"
    }
    
    struct Fonts{
        static let nimbus_bold = "NimbusSanL-Bol"
        static let gibson_regular = "Gibson-regular"
        static let gibson_bold = "Gibson-bold"
        static let gibson_BoldItalic = "Gibson-BoldItalic"
    }
    
    struct AlertMessages{
        static let scanningStoped = "Scanning stoped"
        static let bluetoothPoweredOff = "Bluetooth is powered off."
        static let bluetoothIsResetting = "Bluetooth is resetting."
        static let bluetoothUnauthorized = "You are not authorized to use Bluetooth."
        static let bluetoothIsNotSupported = "Bluetooth is not supported on this device."
    }
}
