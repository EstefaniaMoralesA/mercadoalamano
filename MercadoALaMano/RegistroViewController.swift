 
// LoginViewController.swift
// MercadoALaMano
// 
// Created by Estefanía Morales Abud on 31/05/17.
// Copyright © 2017 com.gueros. All rights reserved.
 
 
 
 import UIKit
 
 class RegistroViewController: UIViewController, UITextFieldDelegate
 {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func signIn(_ sender: Any) {
        var error = 0
        let nameText = validateName()
        if(nameText == nil){
            changeColorLine(textField: name, color: UIColor.red)
            error = 1
        }else{
            changeColorLine(textField: name, color: UIColor.white)
        }
        
        let emailText = validateEmail()
        if(emailText == nil){
            changeColorLine(textField: email, color: UIColor.red)
            error = 1
        }else{
            changeColorLine(textField: email, color: UIColor.white)
        }
        
        let phoneNumber = validatePhone()
        if(phoneNumber == nil){
            changeColorLine(textField: phone, color: UIColor.red)
            error = 1
        }else{
            changeColorLine(textField: phone, color: UIColor.white)
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
        
        registro(nameText, email: emailText, phone: phoneNumber, password: passwordText, tipo: 0);
    }
    
    func registro(_ name: String?, email: String?, phone: String?, password: String?, tipo: Int)
    {
        let jsonObject: [String: Any] = [
            "nombre": name!,
            "apellidos": "",
            "email": email!,
            "tipo": tipo,
            "password": password!,
            "telefono": phone!
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                
                Requests().registro(JSONString, result: {
                    (result, mensaje) in
                
                    if (result)
                    {
                        let alertVC = UIAlertController(title: "Registro Valido!", message: "Gracias por registrarte en Mercado a la Mano", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertVC.addAction(okAction)
                        DispatchQueue.main.async() { () -> Void in
                            self.present(alertVC, animated: true, completion: nil)
                        }
                        return;
                    }
                    else{
                        let alertVC = UIAlertController(title: "Error!", message: mensaje, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertVC.addAction(okAction)
                        DispatchQueue.main.async() { () -> Void in
                            self.present(alertVC, animated: true, completion: nil)
                        }
                    }
                })
            }
            else
            {
                print("Error serializando el objeto del registro");
            }
            
        } catch {
            let alertVC = UIAlertController(title: "Error!", message: "Se produjo un error, vuelva a intentarlo", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(okAction)
            DispatchQueue.main.async() { () -> Void in
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate weak var gestureRecognizer : UIGestureRecognizer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        phone.delegate = self
        password.delegate = self
        email.delegate = self
        name.returnKeyType = UIReturnKeyType.next
        phone.returnKeyType = UIReturnKeyType.next
        password.returnKeyType = UIReturnKeyType.go
        email.returnKeyType = UIReturnKeyType.next
        customizeTextField(textField: name, icon: .FAPencil, string: "Nombre y Apellidos")
        customizeTextField(textField: phone, icon: .FAPhone, string:"Telefono")
        customizeTextField(textField: password, icon: .FALock, string:"Contraseña")
        customizeTextField(textField: email, icon: .FAEnvelopeO, string:"Email")
        customizeSignInButton(button: signInButton, string: "REGISTRARME")
        customizeBorderlessButton(button: loginButton, string: "Iniciar Sesión")

        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func changeOfType(_ sender: Any) {
        let placeholderAttrs = [ NSForegroundColorAttributeName : UIColor.gray]
        var phText = ""
        switch (type.selectedSegmentIndex)
        {
            case 0:
                phText = "Nombre y Apellidos"
                name.text = ""
                break
            case 1:
                phText = "Razón Social"
                name.text = ""
                break
            default:
                phText = "Nombre y Apellidos"
                name.text = ""
                break
        }
        let placeholder = NSAttributedString(string: phText, attributes: placeholderAttrs)
        name.attributedPlaceholder = placeholder
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.name{
            self.email.becomeFirstResponder()
        }
        else{
            if textField == self.email{
                self.phone.becomeFirstResponder()
            }
            else{
                if textField == self.phone{
                    self.password.becomeFirstResponder()
                }
                else{
                    
                }
            }
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
        self.view.frame.origin.y = self.view.frame.origin.y - self.type.frame.origin.y + 20
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
    
    func validateName()->String?{
        guard let nameText = name.text, nameText != "" else{
            return nil
        }
        
        return nameText
    }
    
    func validateEmail()->String?{
        guard let emailText = email.text, emailText != "" else{
            return nil;
        }
        
        return emailText
    }
    
    func validatePhone()->String?{
        guard let phoneNumber = phone.text, phoneNumber != "" else{
            return nil;
        }
        
        return phoneNumber
    }
    
    func validatePassword()->String?{
        guard let passwordText = password.text, passwordText != "" else{
            return nil;
        }
        
        return passwordText
    }
    
    func customizeSignInButton(button:UIButton, string: String)
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
    }
 }
 
