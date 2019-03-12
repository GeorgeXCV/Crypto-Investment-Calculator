//
//  ViewController.swift
//  Simple Crypto Calculator
//
//  Created by George on 03/01/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var cryptoName = ""
    
    
    @IBOutlet var cryptoNameButton: UIButton!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If cryptoName has a value, use that as title
        if cryptoName.count > 1 {
            cryptoNameButton.setTitle(cryptoName, for: .normal)
        }
    
        
    }
    
    
    // Investment / current coin price = How many coins you would get
    // Amount of coins * Projected value per coin = Investment worth
    // If I invest £100 in EOS which is £1.85 a coin, £100 / £1.85 = 54 Coins. If value per coin goes up to £10, (54 * 10), my investment is worth £540
    


}

