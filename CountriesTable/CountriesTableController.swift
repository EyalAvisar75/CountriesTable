//
//  CountriesTableController.swift
//  CountriesTable
//
//  Created by eyal avisar on 15/01/2021.
//

import UIKit


class CountriesTableController: UITableViewController {

    var countries:[Country] = []
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", image: nil, primaryAction: nil, menu: menuItems())
        
        getCountriesData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    //MARK: helper functions
    func menuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "By name"){(_) in
                self.sortCountriesTableByName()
            },
            UIAction(title: "By area"){(_) in
                self.sortCountriesTableByArea()
            }
        ])
        
        return menuItems
    }
    
    
    func offerSetting(_ animated: Bool) {
        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func populateTable(json:[[String:Any]]) {
        for country in json {
            let name = country["name"] as! String
            let nativeName = country["nativeName"] as! String
            let area = country["area"] != nil ? country["area"] as! Double : 0.0
            let borders = country["borders"]! as! [String]
            let code = country["alpha3Code"] as? String ?? "FRA"

            
            
            let tableCountry = Country(name: name, nativeName: nativeName, area: area, borders: borders, code: code)
            
            
            self.countries.append(tableCountry)
        }
        DispatchQueue.main.sync {
               self.tableView.reloadData()
              }
    }
    
    
    func getCountriesData() {
        if let url = URL(string: "https://restcountries.eu/rest/v2/all?fields=name;nativeName;area;borders;alpha3Code") {
           URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                      do {
                        let json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]])
                        self.populateTable(json: json!)
                      }
                   }
               }.resume()
        }
        

    }
    
        
    // MARK: - sort funcs

    
    func sortCountriesTableByName() {
        countries.sort{$0.name < $1.name}
        tableView.reloadData()
    }
    
    func sortCountriesTableByArea() {
        countries.sort{$0.area < $1.area}
        tableView.reloadData()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            print("Wifi Connection")
        case .cellular:
            print("Cellular Connection")
        case .unavailable:
            print("No Connection")
            offerSetting(true)
            
        case .none:
            print("No Connection")
        }
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
        cell.countryAreaLabel.text = "Area: " + String(countries[indexPath.row].area) + " Kms Squared"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bordersTable = (storyboard?.instantiateViewController(identifier: "BordersTable"))! as! BordersTableViewController
        
//        print("before \(countries[indexPath.row].borders)")
        
        for country in countries {
            print(countries[indexPath.row].borders, country.code)
            if countries[indexPath.row].borders.contains(country.code) {
                bordersTable.countries.append(country)
            }
        }
//        bordersTable.countries = countries
        
        (navigationController?.pushViewController(bordersTable, animated: true))
            
        print(countries[indexPath.row])
    }
    
}
