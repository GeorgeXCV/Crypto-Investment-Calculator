//
//  ViewController.swift
//  Simple Crypto Calculator
//
//  Created by George on 03/01/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

// Tracker for currecny selection
public var buttonCounter = 0


class ViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet var investAmount: UITextField!
    @IBOutlet var worthAmount: UITextField!
    @IBOutlet var wouldBe: UILabel!
    @IBOutlet var cryptoNameButton: UIButton!
    @IBOutlet var currencyButton: UIButton!
    @IBOutlet var currencySymbol: UILabel!
    @IBOutlet var currencySymbol2: UILabel!
    
    // Arrays to store our currency JSON data
    var currencies = [String]()
    var symbols = [String]()
    
    // Store Crypto JSON results from tableview here
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
        performSelector(onMainThread: #selector(fetchJSON), with: nil, waitUntilDone: false)
//        performSelector(inBackground: #selector(fetchJSON), with: nil)
    
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
            currencies = jsonFiat.map { $0.name }
            symbols = jsonFiat.map { $0.symbol }
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
        currencySymbol.text = symbols[buttonCounter]                        // Set currency symbol too
        currencySymbol2.text = currencySymbol.text
//        finalURL = baseURL + currencyArray[buttonCounter]
//        currencySelected = currencySymbolArray[buttonCounter]
//        getBitcoinData(url: finalURL)
    }
    
    @IBAction func currencySwitched(_ sender: UIButton) {
        // Each time button pressed, add one to our tracker and run saveCurrecny method.
        buttonCounter += 1
        saveCurrency()
    }
    
    func loadCurrencySetting() {
        if let currency: Int? = UserDefaults.standard.integer(forKey: "currency") {
            buttonCounter = currency!
            currencyButton.setTitle(currencies[buttonCounter], for: .normal)
            currencySymbol.text = symbols[buttonCounter]
            currencySymbol2.text = currencySymbol.text
            //            finalURL = baseURL + currencyArray[currency!]
            //            currencySelected = currencySymbolArray[currency!]
            //            getBitcoinData(url: finalURL)
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
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale.current
        
            // Convert currency here

        
            wouldBe.text = currencyFormatter.string(for: totalValue)!
            
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

