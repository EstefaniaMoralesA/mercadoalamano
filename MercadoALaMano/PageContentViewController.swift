//
//  PageContentViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 22/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.image = UIImage(named: strPhotoName)
        titulo.text = strTitle
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
