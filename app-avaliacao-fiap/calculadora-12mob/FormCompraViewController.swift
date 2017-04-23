//
//  FormCompraViewController.swift
//  calculadora-12mob
//
//  Created by Lucas Henrique on 4/20/17.
//  Copyright © 2017 Lucas Henrique. All rights reserved.
//

import UIKit
import CoreData

class FormCompraViewController: UIViewController {
    
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var estado: UITextField!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var chkCartao: UISwitch!
    
    var picker : UIPickerView!
    
    var estados : [State] = []
    var produto: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if produto != nil {
            if let description = produto.product {
                descricao.text = description
            }
            
            if let img = produto.cover {
                cover.image = UIImage(data: img as Data)
            }
            
            if let state = produto.estado {
                estado.text = state.name
            }
            
            valor.text = "\(produto.price)"
            chkCartao.isOn = produto.cartao
        } else {
            produto = Product(context: context())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadState()
        
        estado.inputView = createPickerView()
        estado.inputAccessoryView = prepareAcessories()
    }
    
    func done(){
        let index = picker.selectedRow(inComponent: 0)
        let selected = estados[index]
        
        estado.text = selected.name!
        estado.resignFirstResponder()
    }
    
    func cancel(){
        estado.resignFirstResponder()
    }
    
    func loadState(){
        let fetch : NSFetchRequest<State> = State.fetchRequest()
        let ordering = NSSortDescriptor(key: "name", ascending: true)
        fetch.sortDescriptors = [ordering]
        
        do {
            estados = try context().fetch(fetch)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func openStates(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "state-controller") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let desc = descricao.text {
            produto.product = desc
        }
        
        if let img = cover.image {
            produto.cover = UIImagePNGRepresentation(img)! as NSData
        }
        
        if let state = estado.text {
            produto.estado = estados.filter({$0.name! == state}).first
        }
        
        if let price = valor.text {
            produto.price = Double(price)!
        }
        
        produto.cartao = chkCartao.isOn
        
        do {
            try context().save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func changeCover(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Selecione a Fonte", message: "Defina de onde você irá importar a foto.", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Biblioteca", style: .default) { (action: UIAlertAction) in
            self.showImagePicker(type: .photoLibrary)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePicker(type: .camera)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker(type : UIImagePickerControllerSourceType){
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func prepareAcessories() -> UIToolbar {
        let cancelAction = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        let doneAction = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(done))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.items = [cancelAction, space, doneAction]
        
        return toolbar
    }
    
    func createPickerView() -> UIPickerView {
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }
    
}

extension FormCompraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        cover.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension FormCompraViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count
    }
    
}

extension FormCompraViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        estado.text = estados[row].name!
    }
    
}
