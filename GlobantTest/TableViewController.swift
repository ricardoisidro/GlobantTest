//
//  TableViewController.swift
//  GlobantTest
//
//  Created by Ricardo Isidro on 2/20/19.
//  Copyright © 2019 RicardoIsidro. All rights reserved.
//

import UIKit

struct cellInfo {
    var name = String()
    var height = String()
}

class TableViewController: UITableViewController {
    
    var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    
    var tableViewData = [cellInfo]()
    
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var jsonResult = People()
        //var res = People()
        
        let urlString = "https://swapi.co/api/people/"
        let url = URL(string: urlString)
        let req = NSMutableURLRequest(url: url!)

        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "GET"
        
        dataTask?.cancel()
        dispatchGroup.enter()
        dataTask = mySession.dataTask(with: req as URLRequest, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonResult = try jsonDecoder.decode(People.self, from: data)
                    self.dispatchGroup.leave()
                }
                catch let ex{
                    print("Error deserializing json: \(ex)")
                }
            }
            else if let error = error {
                print("Error: \(error)")
            }
        })
        dataTask?.resume()
        
        dispatchGroup.notify(queue: .main) {
            self.fill(result: jsonResult)
            self.tableView.reloadData()
        }
        
    }
    
    func fill(result: People) {
        if result.results.count > 0 {
            for value in result.results {
                tableViewData.append(cellInfo(name: value.name, height: value.height))
            }
        }
        else{
            let ac = UIAlertController(title: "Aviso", message: "No se encuentran registros", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewData.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Nombre: " + tableViewData[indexPath.row].name
        cell.detailTextLabel?.text = "Altura: " + tableViewData[indexPath.row].height
        return cell
    }

}
