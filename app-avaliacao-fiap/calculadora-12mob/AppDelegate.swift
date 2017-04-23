//
//  AppDelegate.swift
//  calculadora-12mob
//
//  Created by Lucas Henrique on 4/20/17.
//  Copyright © 2017 Lucas Henrique. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    lazy var persistenteContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (description: NSPersistentStoreDescription?, error:Error?) in
            if let e = error {
                print(e)
                fatalError("Nao foi possivel iniciar o app")
            }
            
            print("CoreDate iniciado com sucesso")
        }
        
        return container
    }()
    
}

