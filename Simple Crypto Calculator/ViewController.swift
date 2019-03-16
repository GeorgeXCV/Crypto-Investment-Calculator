//
//  ViewController.swift
//  Simple Crypto Calculator
//
//  Created by George on 03/01/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet var investAmount: UITextField!
    @IBOutlet var worthAmount: UITextField!
    @IBOutlet var wouldBe: UILabel!
    @IBOutlet var cryptoNameButton: UIButton!
    
    // Store JSON results here
    var cryptoName = ""
    var cryptoPrice: Double?
    
    // Empty property to store calcuations
    var coinsBought: Double = 0
    var totalValue: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        // If cryptoName has a value, use that as title
        if cryptoName.count > 1 {
            cryptoNameButton.setTitle(cryptoName, for: .normal)
        }
    }
    
    // When investment amount eneted
    @IBAction func investmentEntered(_ sender: Any) {
        // If text value exists, perform below code
        guard let text = investAmount.text else {
            return
        }
        if let invest = Double(text) { // If we can convert value of textfield to Double
         if let coinPrice = cryptoPrice { // And if cryptoPrice has a value
            coinsBought = invest / coinPrice // Investment amount / current coin price = How many coins we would buy
        }
    }
}
    
    // When projected value of coin entered
    @IBAction func projectionEntered(_ sender: Any) {
        // If both text fields have text, run the code below
        guard let text = worthAmount.text, let text2 = investAmount.text else {
            return
        }
        
        if let projection = Double(text) { // If worthAmount has text to convert to Double
            totalValue = coinsBought * projection    // Amount of coins we can buy * Projected value per coin = Investment worth
        
            
           wouldBe.text = "\(totalValue)" // Add the total value to investment worth label
     }
    }
 
    // If I invest £100 in EOS which is £1.85 a coin, £100 / £1.85 = 54 Coins. If value per coin goes up to £10, (54 * 10), my investment is worth £540
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

