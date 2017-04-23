//
//  FirstViewController.swift
//  calculadora-12mob
//
//  Created by Lucas Henrique on 4/20/17.
//  Copyright © 2017 Lucas Henrique. All rights reserved.
//

import UIKit
import CoreData

class ComprasViewController: UITableViewController {
    
    var dataSource: [Product]!
    
    var empty: UILabel = {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.text = "Não existe produtos na lista"
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProducts()
        
        if dataSource.count == 0 {
            self.tableView.backgroundView = empty
        }
    }
    
    func loadProducts(){
        let fetch: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            self.dataSource = try context().fetch(fetch)
            tableView.reloadData();
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "form-produto") as! FormCompraViewController
        vc.produto = dataSource[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! CompraTableViewCell
        
        let item = dataSource[indexPath.row]
        
        if let title: String = item.product { row.product.text = title }
        if let img : Data = item.cover as Data? { row.cover.image = UIImage(data: img) }
        row.price.text = "U$ \(item.price)"
        
        return row
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}
