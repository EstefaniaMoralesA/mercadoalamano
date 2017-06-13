//
//  BackgroundViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 11/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "segueToLogin", sender: nil)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
