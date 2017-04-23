//
//  ViewController.swift
//  calculadora-12mob
//
//  Created by Lucas Henrique on 4/20/17.
//  Copyright © 2017 Lucas Henrique. All rights reserved.//

import UIKit
import CoreData

extension UIViewController {
    
    func context() -> NSManagedObjectContext {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.persistenteContainer.viewContext
    }
    
}
