//
//  StoreModel.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 09/03/23.
//


import UIKit

struct Store {
    let headerTitle: String?
    let headerSubtitle: String?
    let cards: [Cards]
}


struct Cards {
    let img: UIImage
    let name: String
    let price: Double?
    let subtitle: String?
    let instalment: Double?
    let isBtnAvailable: Bool?
}


struct StoreData {
    let data = [
        Store(headerTitle: "Apollo Care & Protect", headerSubtitle: "Protect your new scooter", cards: [
            Cards(img: UIImage(named: "theftAndLoss")!, name: "Apollo Care + Theft and Loss", price: 129, subtitle: nil, instalment: 6.99, isBtnAvailable: nil),
            Cards(img: UIImage(named: "apolloCare")!, name: "Apollo Care + Theft and Loss", price: 129, subtitle: nil, instalment: 6.99, isBtnAvailable: nil)
        ]),
        Store(headerTitle: "Accessories", headerSubtitle: "Buy new great stuff for your scooter", cards: [
            Cards(img: UIImage(named: "appoloBag")!, name: "Apollo Bag", price: 19.99, subtitle: "Some interesting description here", instalment: nil, isBtnAvailable: true)
        ]),
        Store(headerTitle: "Apollo Care & Protect", headerSubtitle: "Protect your new scooter", cards: [
            Cards(img: UIImage(named: "phantom")!, name: "Phantom V3 Kit", price: nil, subtitle: "At magnum periculum adiit in oculis quidem exercitus quid ex eo delectu rerum.", instalment: nil, isBtnAvailable: true)
        ])
    ]
}






