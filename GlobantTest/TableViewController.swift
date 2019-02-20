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
    var done: Bool = false
    
    var tableViewData = [cellInfo]()

    var activityIndicatorView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var jsonResult = People()

        let urlString = "https://swapi.co/api/people/"
        let url = URL(string: urlString)
        let req = NSMutableURLRequest(url: url!)

        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "GET"
        
        //Make the request
        dataTask?.cancel()
        dataTask = mySession.dataTask(with: req as URLRequest ) { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            guard let data = data else {
                self.done = true
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonResult = try jsonDecoder.decode(People.self, from: data)
                self.done = true
            }
            catch let ex{
                print("Error deserializing json: \(ex)")
            }
        }
        dataTask?.resume()
        
        while !self.done {
            usleep(100000)
        }
        
        if jsonResult.results.count > 0 {
            for value in jsonResult.results {
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Nombre: " + tableViewData[indexPath.row].name
        cell.detailTextLabel?.text = "Altura: " + tableViewData[indexPath.row].height

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
