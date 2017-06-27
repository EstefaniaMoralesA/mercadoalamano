//
//  DetailViewController.swift
//  MercadoALaMano
//
//  Created by Raul M on 24/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    var index = 0
    var productName : String = ""
    var image : String = ""
    var price : Double = 0.0
    var currentItems = 0
    var total = 0.0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var totalPrice: UILabel!
    

    @IBOutlet weak var popUpView: UIView!
    
    fileprivate weak var gestureRecognizer : UIGestureRecognizer?

    @IBAction func textFieldChanged(_ sender: Any) {
        currentItems = (quantityTextField.text! as NSString).integerValue
        getTotalPrice()
    }
    func textFieldDidChange(textField: UITextField) {
        getTotalPrice()
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: Any) {
        currentItems += 1
        quantityTextField.text = currentItems.description
        getTotalPrice()
    }
    @IBAction func removeItem(_ sender: Any) {
        if currentItems > 0 {
            currentItems -= 1
            quantityTextField.text = currentItems.description
            getTotalPrice()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        quantityTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        let stringCurrentPrice = NSString(format: "$%.2f", price) as String

        
        nameLabel.text = productName
        priceLabel.text = stringCurrentPrice
        productImage.image = UIImage(named: image)
        totalPrice.text = "Total: $" + total.description
        
        quantityTextField.text = "\(currentItems)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func moveViewUp(){
        
        guard self.gestureRecognizer == nil else{
            return
        }
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gr)
        self.gestureRecognizer = gr
        
        self.view.frame.origin.y = self.view.frame.origin.y - self.productImage.frame.origin.y - 10

    }
    
    func moveViewDown(){
        
        if let gr = self.gestureRecognizer{
            self.view.removeGestureRecognizer(gr)
        }
        
        self.view.frame.origin.y = 0
        self.gestureRecognizer = nil
    }

    
    
    func getTotalPrice(){
        total = price * Double(currentItems)
        totalPrice.text = "Total: $" + total.description
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
