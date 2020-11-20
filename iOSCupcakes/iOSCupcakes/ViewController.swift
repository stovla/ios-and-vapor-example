//
//  ViewController.swift
//  iOSCupcakes
//
//  Created by Vlastimir on 01/05/2020.
//  Copyright © 2020 Vlastimir. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var cupcakes = [Cupcake]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
    }

    func fetchData() {
        let url = URL(string: "http://localhost:8080/cupcakes")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "0.")
                return
            }
        
            let decoder = JSONDecoder()
        
            if let cakes = try? decoder.decode([Cupcake].self, from: data) {
                DispatchQueue.main.async {
                    self.cupcakes = cakes
                    self.tableView.reloadData()
                    print("Loaded \(cakes.count) cupcakes.")
                }
            } else {
                print("Unable to parse JSON data")
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cupcakes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cake = cupcakes[indexPath.row]
        cell.textLabel?.text = "\(cake.name) - $\(cake.price)"
        cell.detailTextLabel?.text = cake.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cake = cupcakes[indexPath.row]
        
        let ac = UIAlertController(title: "Order a \(cake.name)?", message: "Please enter your name", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Order it!", style: .default) { action in
            guard let name = ac.textFields?[0].text else {
                return
            }
            self.order(cake, name: name)
        })
        present(ac, animated: true, completion: nil)
    }

    func order(_ cake: Cupcake, name: String) {
        let order = Order(cakeName: cake.name, buyerName: name)
        let url = URL(string: "http://localhost:8080/order")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(order)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let item = try? decoder.decode(Order.self, from: data) {
                    print(item.buyerName)
                } else {
                    print("Bad JSON received back.")
                }
            }
        }.resume()
    }
}

