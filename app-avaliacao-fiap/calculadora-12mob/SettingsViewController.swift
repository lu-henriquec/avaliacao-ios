//
//  SettingsViewController.swift
//  calculadora-12mob
//
//  Created by Lucas Henrique on 4/20/17.
//  Copyright © 2017 Lucas Henrique. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableViewEstados: UITableView!
    
    var dataSource: [State] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStates()
        
        tfDolar.text = UserDefaults.standard.string(forKey: "key_dolar")
        tfIOF.text = UserDefaults.standard.string(forKey: "key_iof")
    }
    
    func loadStates() {
        do {
            let request: NSFetchRequest<State> = State.fetchRequest()
            self.dataSource = try context().fetch(request)
            
            tableViewEstados.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func btnAddState(_ sender: Any) {
        let alert = UIAlertController(title: "Adicionar Estado", message: "Adicione o Estado", preferredStyle: .alert)
        
        alert.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Estado"
            textfield.keyboardType = .default
        }
        
        alert.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Imposto"
            textfield.keyboardType = .decimalPad
        }
        
        let save = UIAlertAction(title: "Salvar", style: .default) { (action:UIAlertAction) in
            let state = State(context: self.context())
            
            state.name = alert.textFields![0].text
            state.tax = Double(alert.textFields![1].text!)!
            
            do {
                try self.context().save()
                
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (alert: UIAlertAction) in
            
        }
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

    

}

extension SettingsViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            UserDefaults.standard.setValue(textField.text, forKey: "key_dolar")
        }
        
        if textField.tag == 1 {
            UserDefaults.standard.setValue(textField.text, forKey: "key_iof")
        }
        
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = dataSource[indexPath.row]
        context().delete(item)
        
        let index = dataSource.index(of: item)
        dataSource.remove(at: index!)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
        
        row.textLabel?.text = dataSource[indexPath.row].name
        row.detailTextLabel?.text = "\(dataSource[indexPath.row].tax)"
        
        return row
    }
    
}
