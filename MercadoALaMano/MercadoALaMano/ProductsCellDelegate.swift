//
//  ProductsCellDelegate.swift
//  MercadoALaMano
//
//  Created by Raul M on 26/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit


protocol ProductsCellDelegate {
    func addToDict(key: String, dict: NSMutableDictionary) -> Bool
}

