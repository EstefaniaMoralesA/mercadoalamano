//
//  LoginViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 31/05/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//


import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeTextField(textField: username, icon: .FAEnvelopeO, string: "Username")
        customizeTextField(textField: password, icon: .FALock, string:"Password")
        customizeLoginButton(button: loginButton, string: "LOG IN")
        customizeForgotPasswordButton(button: forgotPasswordButton, string: "¿Olvidaste tu contraseña?")
    }
    
    func customizeLoginButton(button:UIButton, string:String)
    {
         button.layer.borderWidth = 1.5
         button.layer.cornerRadius = 5;
         button.layer.borderColor = UIColor.white.cgColor
         button.setTitle(string, for: .normal)
    }
    
    func customizeForgotPasswordButton(button:UIButton, string:String)
    {
        button.setTitle(string, for: .normal)
    }
    
    func customizeTextField(textField:UITextField, icon:FAType, string: String)
    {
        textField.setLeftViewFAIcon(icon: icon, leftViewMode: .always, textColor: .white, backgroundColor: .clear, size: nil)
        
        let placeholderAttrs = [ NSForegroundColorAttributeName : UIColor.white]
        let placeholder = NSAttributedString(string: string, attributes: placeholderAttrs)
        
        textField.attributedPlaceholder = placeholder
        
        configureTextField(x: 0, y: textField.frame.size.height-1.0, width: textField.frame.size.width, height:1.0, textField: textField)
        
    }
    
    func configureTextField(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,textField:UITextField)
        
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: x, y: y, width: width, height: height)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.addSublayer(bottomLine)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

