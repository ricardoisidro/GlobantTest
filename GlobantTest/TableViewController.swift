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
    
    
    var tableViewData = [cellInfo]()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setActivityIndicator()
        setNavigationBar(titleText: "GlobantTest", titleColor: .black)
        makeRequest()
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = tableViewData.count
        if num > 5 {
            return 5
        }
        else {
            return num
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Nombre: " + tableViewData[indexPath.row].name
        cell.detailTextLabel?.text = "Altura: " + tableViewData[indexPath.row].height
        return cell
    }
    
    func fill(result: People) {
        if result.results.count > 0 {
            for value in result.results {
                tableViewData.append(cellInfo(name: value.getName(), height: value.getHeight()))
            }
        }
        else{
            let ac = UIAlertController(title: "Aviso", message: "No se encuentran registros", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // MARK: - API Call
    
    func makeRequest() {
        
        var dataTask: URLSessionDataTask?
        let mySession = URLSession.shared
        
        let dispatchGroup = DispatchGroup()
        var jsonResult = People()
        
        let urlString = "https://swapi.co/api/people/"
        let url = URL(string: urlString)
        let req = NSMutableURLRequest(url: url!)
        
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "GET"
        
        dataTask?.cancel()
        dispatchGroup.enter()
        dataTask = mySession.dataTask(with: req as URLRequest, completionHandler: { (data, response, error) in
            defer {
                dataTask = nil
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonResult = try jsonDecoder.decode(People.self, from: data)
                    dispatchGroup.leave()
                }
                catch let ex{
                    print("Error deserializing json: \(ex)")
                }
            }
            else if let error = error {
                self.hideOrShowActivityIndicator(animated: false)
                print("Error: \(error)")
            }
        })
        dataTask?.resume()
        
        dispatchGroup.notify(queue: .main) {
            self.fill(result: jsonResult)
            self.tableView.reloadData()
            self.hideOrShowActivityIndicator(animated: false)
        }
    }
    
    // MARK: - ActivityIndicator
    
    func setActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.hidesWhenStopped = true
        hideOrShowActivityIndicator(animated: true)
    }
    
    func hideOrShowActivityIndicator(animated: Bool){
        if animated {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - NavigationBar
    
    func setNavigationBar(titleText: String, titleColor: UIColor) {
        
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        let color = [NSAttributedString.Key.foregroundColor:titleColor]
        self.navigationController?.navigationBar.titleTextAttributes = color
        self.navigationController?.navigationBar.topItem?.title = titleText
    }

}
