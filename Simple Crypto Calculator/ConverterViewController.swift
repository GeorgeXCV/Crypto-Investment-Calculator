//
//  ConverterViewController.swift
//  Simple Crypto Calculator
//
//  Created by George on 04/06/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var coinImage: UIImageView!
    @IBOutlet var cryptoLabel: UILabel!
    @IBOutlet var priceChangeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
}

class ConverterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var tableView: UITableView!
    
    // Array of our JSON Struct
    var cryptocurrencies = [Cryptocurrency]()
    
    // Arrays to store our currency JSON data
    var currencies = [String]()
    var symbols = [String]()
    var exchangerates = [Double]()
    
    // Store our chosen property from exchangerates array
    var rate: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.lightGray
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white;
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)

    }
    
    
    @objc func fetchJSON() {
        // API for coin data
        let urlString = "https://api.coinstats.app/public/v1/coins?skip=0&limit=200"
        
        if let url = URL(string: urlString) {           // If URL is valid
            if let data = try? Data(contentsOf: url) {  // Create a Data object and return the contents of the URL
                // We're OK to parse!
                parse(json: data)
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
        if let jsonCrypto = try? decoder.decode(Cryptocurrencies.self, from: json) {
            cryptocurrencies = jsonCrypto.coins    // JSON was converted successfully, assign the cryptocurrencies array to our Coins property then reload the table view.
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptocurrencies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let crypto = cryptocurrencies[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.white
        
        cell.rankLabel?.text =  "\(crypto.rank)"
        cell.rankLabel?.textColor = UIColor.white
        
        let imageUrl = URL(string: crypto.icon)!
        let imageData = try! Data(contentsOf : imageUrl)
        let image = UIImage(data: imageData)
        cell.coinImage?.image = image
        
        cell.cryptoLabel?.text = crypto.name
        cell.cryptoLabel?.textColor = UIColor.white
        
        
        cell.priceChangeLabel?.text = "\(crypto.priceChange1d)" + "% "
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = symbols[buttonCounter]
        
        let totalValue = crypto.price * rate
        
        cell.priceLabel?.text = currencyFormatter.string(for: totalValue)!

//        cell.priceChangeLabel?.textColor = UIColor.white
        if crypto.priceChange1d < 0 {
            cell.priceChangeLabel?.textColor = UIColor.red
            cell.priceLabel?.textColor = UIColor.red

        } else {
            cell.priceChangeLabel?.textColor = UIColor.green
            cell.priceLabel?.textColor = UIColor.green

        }

        

        
//        cell.textLabel?.text = "\(crypto.rank) " + crypto.name + "\(crypto.priceChange1d)" + "% " + "\(crypto.price)"
//
//        cell.sizeToFit()
//
//        // Refactor for error needed
//        let imageUrl = URL(string: crypto.icon)!
//        let imageData = try! Data(contentsOf : imageUrl)
//        let image = UIImage(data: imageData)
//        cell.imageView?.image = image
//
        
        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//            as! HeadlineTableViewCell
//
//        let headline = headlines[indexPath.row]
//        cell.headlineTitleLabel?.text = headline.title
//        cell.headlineTextLabel?.text = headline.text
//        cell.headlineImageView?.image = UIImage(named: headline.image)
//
//        return cell
//    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Network Error", message: "We can't get price data! Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    

    
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
