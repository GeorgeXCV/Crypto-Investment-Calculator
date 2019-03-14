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
    var totalValue: Double?
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        // If cryptoName has a value, use that as title
        if cryptoName.count > 1 {
            cryptoNameButton.setTitle(cryptoName, for: .normal)
        }
    }
    
    
    
    
    @IBAction func investmentEntered(_ sender: Any) {
        guard let text = investAmount.text else {
            return
        }
        if let invest = Double(text) {
         if let coinPrice = cryptoPrice {
            coinsBought = invest / coinPrice
        }
    }
    }
    
    // Investment / current coin price = How many coins you would get
    // Amount of coins * Projected value per coin = Investment worth
    // If I invest £100 in EOS which is £1.85 a coin, £100 / £1.85 = 54 Coins. If value per coin goes up to £10, (54 * 10), my investment is worth £540
    
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let text = investAmount.text, let textTwo = worthAmount.text else {
//        return
//    }
//        if let invest = Double(text) {
//           if let worth = Double(textTwo) {
//            if let price = cryptoPrice {
//                    var amountOfCoins = invest / price
//                    totalValue = amountOfCoins * worth
//                    print(totalValue)
//                    }
//            }
//        }
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        guard let text = investAmount.text else {
//            return
//        }
//
//        if let invest = Double(text) {
//            if let price = cryptoPrice {
//               coinsBought = invest / price
//            }
//        }
//    }

    
    
   
    
    

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

