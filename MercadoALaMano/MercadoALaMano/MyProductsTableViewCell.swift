//
//  MyProductsTableViewCell.swift
//  MercadoALaMano
//
//  Created by Raul M on 25/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

protocol ListCellDelegate {
    func addToDict(key: String, value: Int)
}

class MyProductsTableViewCell : UITableViewCell {
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var imageP: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityTextField: UITextField!
    
    var productsList = NSMutableDictionary()
    
    var delegate : ListCellDelegate?
    
    var quantity = 0
    var index = ""
    let vc = MyProductsListViewController()
    
    @IBAction func removeItem(_ sender: Any) {
        
        if (delegate != nil) {
            quantity = Int(quantityTextField.text!)!
            if quantity > 0 {
                quantity -= 1
//                vc.productsList.setValue(quantity, forKey: index)
                delegate?.addToDict(key: index, value: quantity)
                quantityTextField.text = "\(quantity)"
            }
        }
    }
    @IBAction func addItem(_ sender: Any) {
        if (delegate != nil) {
            quantity = Int(quantityTextField.text!)!
            print(quantity)
            quantity += 1
//            vc.productsList.setValue(quantity, forKey: index)
            delegate?.addToDict(key: index, value: quantity)
            quantityTextField.text = "\(quantity)"
        }
    }
    
    func updateValues() {
        
    }
}
