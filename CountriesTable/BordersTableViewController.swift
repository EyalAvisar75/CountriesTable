//
//  BordersTableViewController.swift
//  CountriesTable
//
//  Created by eyal avisar on 19/01/2021.
//

import UIKit

class BordersTableViewController: UITableViewController {

    var countries:[Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(countries)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return countries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BordersCell", for: indexPath) as! CountryTableCell
        
        cell.countryNameLabel.text = countries[indexPath.row].name
        cell.countryNativeNameLabel.text = countries[indexPath.row].nativeName
        cell.countryAreaLabel.text = "Area: " + String(countries[indexPath.row].area) + " Kms Squared"
        
        return cell
    }
    
 
}
