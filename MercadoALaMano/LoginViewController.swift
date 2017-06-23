//
//  LoginViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 31/05/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//


import UIKit

class LoginController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var mercadoLogo: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var dontHaveAccount: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    fileprivate weak var gestureRecognizer : UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.delegate = self
        username.returnKeyType = UIReturnKeyType.next;
        password.delegate = self
        password.returnKeyType = UIReturnKeyType.go
        
        customizeTextField(textField: username, icon: .FAEnvelopeO, string: "Email")
        customizeTextField(textField: password, icon: .FALock, string:"Contraseña")
        customizeLoginButton(button: loginButton, string: "INICIAR SESIÓN")
        customizeBorderlessButton(button: forgotPasswordButton, string: "Olvidé mi Contraseña")
        customizeDontHaveAccount(label: dontHaveAccount, string: "¿NO TIENES CUENTA?")
        customizeBorderlessButton(button: registerButton, string: "Regístrate")
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        var error = 0
        let emailText = validateUserName()
        if(emailText == nil){
            changeColorLine(textField: username, color: UIColor.red)
            error = 1
        }else{
            changeColorLine(textField: username, color: UIColor.white)
        }
            
        let passwordText = validatePassword()
        if(passwordText == nil){
            changeColorLine(textField: password, color: UIColor.red)
            error = 1
        }else{
            changeColorLine(textField: password, color: UIColor.white)
        }
        
        if(error == 1) {
            return
        }
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.username{
            self.password.becomeFirstResponder()
        }
        else{
            //login(self)
        }
        return true
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
        self.view.frame.origin.y = self.view.frame.origin.y - self.mercadoLogo.frame.origin.y + 40
    }
    
    func moveViewDown(){
        
        if let gr = self.gestureRecognizer{
            self.view.removeGestureRecognizer(gr)
        }
        
        self.view.frame.origin.y = 0
        self.gestureRecognizer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func validateUserName()->String?{
        guard let emailText = username.text, emailText != "" else{
            return nil
        }
        
        return emailText
    }
    
    func validatePassword()->String?{
        guard let passwordText = password.text, passwordText != "" else{
            return nil;
        }
        
        return passwordText
    }

    func customizeLoginButton(button:UIButton, string: String)
    {
         button.layer.borderWidth = 1.5
         button.layer.cornerRadius = 5;
         button.layer.borderColor = UIColor.white.cgColor
         button.setTitle(string, for: .normal)
    }
    
    func customizeBorderlessButton(button:UIButton, string:String)
    {
        button.setTitle(string, for: .normal)
        button.backgroundColor = UIColor.clear
    }
    
    func customizeDontHaveAccount(label: UILabel, string: String)
    {
        label.text = string
    }
    
    func customizeTextField(textField:UITextField, icon:FAType, string: String)
    {
        textField.setLeftViewFAIcon(icon: icon, leftViewMode: .always, textColor: .white, backgroundColor: .clear, size: nil)
        
        let placeholderAttrs = [ NSForegroundColorAttributeName : UIColor.gray]
        let placeholder = NSAttributedString(string: string, attributes: placeholderAttrs)
        
        textField.attributedPlaceholder = placeholder
        
        let screenWidth = UIScreen.main.bounds.width
        textField.frame.size.width = screenWidth * 0.8
        
        configureTextField(x: 0, y: textField.frame.size.height-1.0, width: textField.frame.size.width, height:1.0, textField: textField, color: UIColor.white)
        
    }
    
    func changeColorLine(textField:UITextField, color:UIColor){
        var layerNow: CALayer
        layerNow = (textField.layer.sublayers?[0])!
        layerNow.backgroundColor = color.cgColor
    }
    
    func configureTextField(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,textField:UITextField, color:UIColor)
        
    {
        let bottomLine = CALayer()
        bottomLine.name = "bottomLine";
        bottomLine.frame = CGRect(x: x, y: y, width: width, height: height)
        bottomLine.backgroundColor = color.cgColor
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.addSublayer(bottomLine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

