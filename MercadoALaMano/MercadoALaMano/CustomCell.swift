//
//  CustomCell.swift
//  MercadoALaMano
//
//  Created by Raul M on 23/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

protocol ProductsCellDelegate {
    func addToDict(key: String) -> Bool
}

/* Custom cell for the collection view in the WholeProductsViewController. It implements a protocol
 that will delegate any functionality into the WholeProductsViewController, here only passes data of the
 current cell*/

class CustomCell: UICollectionViewCell {
    
    var delegate: ProductsCellDelegate?
    var productList = NSMutableDictionary()
    var index = ""
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var priceCell: UILabel!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var addListButton: UIButton!
    @IBAction func addItemToList(_ sender: Any) {
        // Add the product to the user productList and if it is in the list
        // it will change the button for a "-" to remove it
        if (delegate != nil) {
            let isInList = delegate?.addToDict(key: index)
            if (isInList)!{
                self.addListButton.setTitle("+", for: .normal)
            } else {
                self.addListButton.setTitle("-", for: .normal)
            }
        }
    }
}
