//
//  ExtensionFile.swift
//  MercadoALaMano
//
//  Created by Estefania Morales Abud on 6/21/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

extension String {
    
func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
        
    }
}

func assignIfNotNil<T>(_ assignable : inout T, assignee : T?){
    
    if let assignee = assignee{
        assignable = assignee
    }
}
