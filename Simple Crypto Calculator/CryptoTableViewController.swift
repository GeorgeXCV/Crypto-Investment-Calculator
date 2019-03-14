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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // API for coin data
        let urlString = "https://api.coinstats.app/public/v1/coins?skip=0&limit=10"
        
        if let url = URL(string: urlString) {           // If URL is valid
            if let data = try? Data(contentsOf: url) {  // Create a Data object and return the contents of the URL
                // We're OK to parse!
                parse(json: data)
                return
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func parse(json: Data) {
        // Creates an instance of JSONDecoder, which is dedicated to converting between JSON and Codable objects.
        let decoder = JSONDecoder()
        
        // Call the decode() method on that decoder, asking it to convert our json data into a Cryptocurrencies object.
        if let jsonCrypto = try? decoder.decode(Cryptocurrencies.self, from: json) {
            cryptocurrencies = jsonCrypto.coins    // JSON was converted successfully, assign the cryptocurrencies array to our Coins property then reload the table view.
            tableView.reloadData()
        }
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cryptocurrencies.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let crypto = cryptocurrencies[indexPath.row]
        
        cell.textLabel?.text = crypto.name
        
        cryptoPrice = crypto.price  // Store price in our empty property
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)
        cellName = cell!.textLabel!.text!                                   // Copy text from select Cell to our empty property
        performSegue(withIdentifier: "cryptoSelected", sender: indexPath)   // Go back to previous View
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If go back segue has been triggered
        if segue.identifier == "cryptoSelected" {
            let vc = segue.destination as! ViewController           // We want to access ViewController
//            vc.cryptoNameButton.setTitle(cellName, for: .normal)
             vc.cryptoName = cellName                               // Pass cellName (no longer empty) to our empty variable on ViewController
             vc.cryptoPrice = cryptoPrice       // Pass price data to our property in ViewController

        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
