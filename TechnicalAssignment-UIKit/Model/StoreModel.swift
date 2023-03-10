//
//  StoreModel.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 09/03/23.
//


import UIKit

struct Store{
    let headerTitle: String
    let headerSubtitle: String
    let cards: [Cards]
}

struct Cards{
    let img: UIImage
    let name: String
    let price: String
    let subtitle: String
}


struct StoreData{
    let data = [Store(headerTitle: "Apollo Care & Protect", headerSubtitle: "Protect your new scooter", cards: [Cards(img: UIImage(named: "sd")!, name: "Apollo Care + Theft and Loss", price: "$129 USD or $6.99/mo.", subtitle: "")]),
                Store(headerTitle: "Accessories", headerSubtitle: "Buy new great stuff for your scooter", cards: [Cards(img: UIImage(named: "sd")!, name: "Apollo Bag", price: "$129 USD or $6.99/mo.", subtitle: "Some interesting description here")]),
                
                Store(headerTitle: "Apollo Care & Protect", headerSubtitle: "Protect your new scooter", cards: [Cards(img: UIImage(named: "sd")!, name: "Phantom V3 Kit", price: "", subtitle: "At magnum periculum adiit in oculis quidem exercitus quid ex eo delectu rerum.")])]
}
