//
//  TotalViewController.swift
//  calculadora-12mob
//
//  Created by Lucas Henrique on 4/20/17.
//  Copyright © 2017 Lucas Henrique. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {
    
    @IBOutlet weak var dolares: UILabel!
    @IBOutlet weak var reais: UILabel!
    
    var products : [Product] = []
    
    var totalDolar : Double!
    var totalReal : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        totalDolar = 0.0
        totalReal = 0.0
        
        let fetch : NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            products = try context().fetch(fetch)
            
            calcular()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func calcular(){
        products.forEach { (product:Product) in
            self.totalDolar = self.totalDolar + product.price
            
            // preco * taxa * cotacao
            let conversao: Double = (product.price * ((product.estado!.tax / 100) + 1)) * UserDefaults.standard.double(forKey: "key_dolar")
            var taxa : Double = 0.0
            
            if product.cartao {
                taxa = Double((UserDefaults.standard.double(forKey: "key_iof") / 100) * conversao)
            }
            
            
            self.totalReal = self.totalReal + conversao + taxa
        }
        
        dolares.text = "$ \(totalDolar!)"
        reais.text = "R$ \(totalReal!)"
    }
    
}
