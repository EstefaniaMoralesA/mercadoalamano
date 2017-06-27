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

class CustomCell: UICollectionViewCell {
    
    var delegate: ProductsCellDelegate?
    var productList = NSMutableDictionary()
    var index = ""
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var priceCell: UILabel!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var addListButton: UIButton!
    @IBAction func addItemToList(_ sender: Any) {
//        let list = FirstViewController()
//        let isInList = list.addToList(key: self.index)
//
        
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
