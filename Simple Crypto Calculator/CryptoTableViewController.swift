//
//  CryptoTableViewController.swift
//  Simple Crypto Calculator
//
//  Created by George on 11/01/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

class CryptoTableViewController: UITableViewController {
    
    // Array of our JSON Struct
    var cryptocurrencies = [Cryptocurrency]()
   
    // Place to store name of cell selected for previous View
    var cellName = ""
    var cryptoPrice: Double?
    var cryptoSymbol = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.lightGray
        
        
        
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cryptocurrencies.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let crypto = cryptocurrencies[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = crypto.name + " (\(crypto.symbol))"
        
        cell.sizeToFit()
        
        // Cell Image Icon 
        let imageUrl = URL(string: crypto.icon)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)
        cell.imageView?.image = image
     
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow           // New property set to selected row
        let cell = tableView.cellForRow(at: indexPath!)             // Property to reference cell selected
        cellName = cell!.textLabel!.text!                           // Copy text from select Cell to our empty property
        
        let crypto = cryptocurrencies[indexPath!.row]                // Access row selected in our JSON
        cryptoPrice = crypto.price                                  // Store price in our empty property
        cryptoSymbol = crypto.symbol                                // Store symbol in our empty property
        
        performSegue(withIdentifier: "cryptoSelected", sender: indexPath)   // Go back to previous View
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If go back segue has been triggered
        if segue.identifier == "cryptoSelected" {
            let vc = segue.destination as! ViewController           // We want to access ViewController
             vc.cryptoName = cellName                               // Pass cellName (no longer empty) to our empty variable on ViewController
             vc.cryptoPrice = cryptoPrice       // Pass price data to our property in ViewController
            vc.cryptoSymbol = cryptoSymbol      // Pass symbol data to our property in ViewController

        }
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

