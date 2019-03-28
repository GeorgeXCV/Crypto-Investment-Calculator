//
//  ViewController.swift
//  Simple Crypto Calculator
//
//  Created by George on 03/01/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

// Tracker for currecny selection button
public var buttonCounter = 0

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet var investAmount: UITextField!
    @IBOutlet var worthAmount: UITextField!
    @IBOutlet var wouldBe: UILabel!
    @IBOutlet var cryptoNameButton: UIButton!
    @IBOutlet var currencyButton: UIButton!
    @IBOutlet var currencySymbol: UILabel!
    @IBOutlet var currencySymbolTwo: UILabel!
    @IBOutlet var currentPrice: UILabel!
    

    // Arrays to store our currency JSON data
    var currencies = [String]()
    var symbols = [String]()
    var exchangerates = [Double]()
    
    // Store our chosen property from exchangerates array
    var rate: Double = 0
    
    // Store Crypto JSON results from tableview here
    var cryptoName = ""
    var cryptoPrice: Double?
//    var cryptoSymbol = ""
    
    // Empty property to store calcuations
    var coinsBought: Double = 0
    var totalValue: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    
        // If cryptoName has a value, use that as title
        if cryptoName.count > 1 {
            cryptoName.removeLast(6)
            cryptoNameButton.setTitle(cryptoName, for: .normal)
        }
        
        if let price = cryptoPrice {
            let realPrice = price * rate
            
            
            currentPrice.text = "Currently = \(realPrice)"
            currentPrice.isHidden = false 
        }
        
        performSelector(onMainThread: #selector(fetchJSON), with: nil, waitUntilDone: false)
//        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        investAmount.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        worthAmount.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    }
    
    @objc func fetchJSON() {
        // API for Currency data
        let urlString = "https://api.coinstats.app/public/v1/fiats"
        
        if let url = URL(string: urlString) {           // If URL is valid
            if let data = try? Data(contentsOf: url) {  // Create a Data object and return the contents of the URL
                // We're OK to parse!
                parse(json: data)
                loadCurrencySetting()
                return
            }
        }
        // Show Error if failed
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    func parse(json: Data) {
        // Creates an instance of JSONDecoder, which is dedicated to converting between JSON and Codable objects.
        let decoder = JSONDecoder()

        // Call the decode() method on that decoder, asking it to convert our json data into a Cryptocurrencies object.
        if let jsonFiat = try? decoder.decode([Currency].self, from: json) {
            // Store JSON data in our empty arrays
            currencies = jsonFiat.map { $0.name }
            symbols = jsonFiat.map { $0.symbol }
            exchangerates  = jsonFiat.map { $0.rate }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    

    func saveCurrency() {
        // If button has been tapped 33 times, reset tracker to 0 as we only have 33 currencies.
        if buttonCounter >= 33 {
            buttonCounter = 0
        }
        UserDefaults.standard.set(buttonCounter, forKey: "currency")        // Save value of buttonCounter in a key called currency
        currencyButton.setTitle(currencies[buttonCounter], for: .normal)    // Set title of currency button
        currencySymbol.text = symbols[buttonCounter]                        // Add active currency symbol to text fields
        currencySymbolTwo.text = currencySymbol.text
        rate = exchangerates[buttonCounter]
        wouldBe.text = "= \(symbols[buttonCounter])"
    }
    
    @IBAction func currencySwitched(_ sender: UIButton) {
        // Each time button pressed, add one to our tracker and run saveCurrecny method.
        buttonCounter += 1
        // Reset text input fields
        investAmount.text = ""
        worthAmount.text = ""
        saveCurrency()
    }
    
    func loadCurrencySetting() {
        if let currency: Int? = UserDefaults.standard.integer(forKey: "currency") {
            buttonCounter = currency!
            currencyButton.setTitle(currencies[buttonCounter], for: .normal)
            currencySymbol.text = symbols[buttonCounter]
            currencySymbolTwo.text = currencySymbol.text
            rate = exchangerates[buttonCounter]
            wouldBe.text = "= \(symbols[buttonCounter])"
        }
        else {
            saveCurrency()
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
            let coinPriceConverted = coinPrice * rate   // Convert price using exchange rate of selected currency
            coinsBought = invest / coinPriceConverted // Investment amount / current coin price = How many coins we would buy
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
            totalValue = coinsBought * projection  // Amount of coins we can buy * Projected value per coin = Investment worth
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
//          currencyFormatter.locale = Locale.current
            currencyFormatter.currencySymbol = symbols[buttonCounter]
            
            // Round up answer
            wouldBe.text = "= " + currencyFormatter.string(for: totalValue)!
            
//            priceLabel.text = currencySelected + currencyFormatter.string(for: bitcoinResult)!
            
//           wouldBe.text = "\(totalValue)" // Add the total value to investment worth label
     }
}
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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

