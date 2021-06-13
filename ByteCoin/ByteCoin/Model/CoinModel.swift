//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Кристина Монастырева on 11.11.2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let price: Double
    let currency: String
    
    var priceString: String {
        return String(format: "%.2f", price)
    }
}
