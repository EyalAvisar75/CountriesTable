//
//  CountriesTableController.swift
//  CountriesTable
//
//  Created by eyal avisar on 15/01/2021.
//

import UIKit

struct Country:CustomStringConvertible {
    var description:String {return "\(name), \(nativeName), \(area)"}
    
    let name:String
    let nativeName:String
    let area:Double
    
    
}
class CountriesTableController: UITableViewController {

    var countries:[Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Sort By Name", style: .plain, target: self, action: #selector(sortCountriesTableByName))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Sort By Area", style: .plain, target: self, action: #selector(sortCountriesTableByArea))
        
        getCountriesData()
    }
    
    func populateTable(json:[[String:Any]]) {
        for country in json {
            let name = country["name"]! as! String
            let nativeName = country["nativeName"]! as! String
            let area = country["area"] != nil ? country["area"] as! Double : 0.0
            
            
            let tableCountry = Country(name: name, nativeName: nativeName, area: area)
            self.countries.append(tableCountry)
        }
        DispatchQueue.main.sync {
               self.tableView.reloadData()
              }
    }
    func getCountriesData() {
        if let url = URL(string: "https://restcountries.eu/rest/v2/all?fields=name;nativeName;area") {
           URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                      do {
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                        self.populateTable(json: json!)
                      }
                   }
               }.resume()
        }
    }
    
    @objc func sortCountriesTableByName() {
        countries.sort{$0.name < $1.name}
        tableView.reloadData()
    }
    
    @objc func sortCountriesTableByArea() {
        countries.sort{$0.area < $1.area}
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryTableCell
        
        cell.countryNameLabel.text = countries[indexPath.row].name
        cell.countryNativeNameLabel.text = countries[indexPath.row].nativeName
        cell.countryAreaLabel.text = "Area: " + String(countries[indexPath.row].area)
        
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
