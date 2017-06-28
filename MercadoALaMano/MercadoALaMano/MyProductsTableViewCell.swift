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

/* CustomCell for the table. It implements a protocol that delegates
 the action of the button to MyProductsListViewController. In here you 
 only get the information of the current cell, the functionality is implemented
 in the other ViewController*/

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
    
    @IBAction func removeItem(_ sender: Any) {
        // Get the value of the textField and take one, then add the value to the dict.
        if (delegate != nil) {
            quantity = Int(quantityTextField.text!)!
            if quantity > 0 {
                quantity -= 1
                delegate?.addToDict(key: index, value: quantity) // Delegation
                quantityTextField.text = "\(quantity)"
            }
        }
    }
    @IBAction func addItem(_ sender: Any) {
        // Get the value of the textField and add one, then add the value to the dict.
        if (delegate != nil) {
            quantity = Int(quantityTextField.text!)!
            print(quantity)
            quantity += 1
            delegate?.addToDict(key: index, value: quantity)
            quantityTextField.text = "\(quantity)"
        }
    }
    
}
