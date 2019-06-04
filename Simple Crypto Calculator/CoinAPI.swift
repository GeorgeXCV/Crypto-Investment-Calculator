//
//  CoinAPI.swift
//  Simple Crypto Calculator
//
//  Created by George on 10/03/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

struct Cryptocurrencies: Codable {
    var coins: [Cryptocurrency]
}

struct Cryptocurrency: Codable {
    var name: String
    var symbol: String 
    var icon: String
    var price: Double
    var rank: Int
    var priceChange1d: Double
}


