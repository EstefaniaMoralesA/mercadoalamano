//
//  LoginViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 31/05/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//


import UIKit
import LocalAuthentication

class LoginController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var touchIDbutton: UIButton!
    @IBOutlet weak var mercadoLogo: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var dontHaveAccount: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    var task : URLSessionTask?
    
    fileprivate weak var gestureRecognizer : UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        if let _ = UserDefaults.standard.object(forKey: MercadoALaManoNSUserDefaultsKeys.User.rawValue) as? String{
            
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userdata")
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            
            if let data = data as? NSArray{
                
                let user = data[0] as! Usuario
                self.performSegue(withIdentifier: "goHome", sender: user)
                self.validateSession()
                
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateSession), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    fileprivate func load() {
        username.delegate = self
        username.returnKeyType = UIReturnKeyType.next;
        password.delegate = self
        password.returnKeyType = UIReturnKeyType.go
        
        customizeTextField(textField: username, icon: .FAEnvelopeO, string: "Email")
        customizeTextField(textField: password, icon: .FALock, string:"Contraseña")
        customizeLoginButton(button: loginButton, string: "INICIAR SESIÓN")
        customizeBorderlessButton(button: forgotPasswordButton, string: "¿Olvidaste tu contraseña?")
        customizeDontHaveAccount(label: dontHaveAccount, string: "¿NO TIENES CUENTA?")
        customizeBorderlessButton(button: registerButton, string: "Regístrate")
        customizeBorderlessButton(button: touchIDbutton, string: "O usar touchID")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func touchID(_ sender: Any) {
        let authenticationContext = LAContext()
        var e: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &e) else {
            showAlertWithTitle(title: "Error", message: "This device does not have TouchID sensor.")
            return
        }
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please let me read your fingerprint...", reply: { [unowned self] (success, error) -> Void in
            if success {
                self.performSegue(withIdentifier: "goHome", sender: self)
            } else {
                if let error = e {
                    let message = self.getErrorMessageForCode(errorCode: (error.code))
                    self.showAlertWithTitle(title: "Error", message: message)
                }
            }
        })
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        var err = 0
        let emailText = validateUserName()
        if(emailText == nil){
            changeColorLine(textField: username, color: UIColor.red)
            err = 1
        }else{
            changeColorLine(textField: username, color: UIColor.white)
        }
            
        let passwordText = validatePassword()
        if(passwordText == nil){
            changeColorLine(textField: password, color: UIColor.red)
            err = 1
        }else{
            changeColorLine(textField: password, color: UIColor.white)
        }
        
        if(err == 1) {
            return
        }
        
        self.performSegue(withIdentifier: "goHome", sender: Any?.self)
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
    
    func getErrorMessageForCode(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            break
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            break
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            break
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            break
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            break
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attepts"
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            break
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            break
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            break
        default:
            message = "Did not find error code on LAError object"
            break
        }
        
        return message
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
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
    
    func validateSession(){
        
        guard let user = Usuario.currentUser, self.task == nil else{
            return
        }
        
        
        self.task = Requests().verifySession(user.id, token: user.session_token , result: {
            (result) in
            
            self.task = nil
            if result {
                print("@@@@ Sesiooooon: valida");
                return
            }
            
            user.logout()
            self.navigationController?.popToRootViewController(animated: false)
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "Sesión caducada", message: "Sentimos interrumpirte, pero tu sesión ya no es válida 😔\nInicia sesión de nuevo para disfrutar de Freends", preferredStyle: .alert)
                self.present(alert, animated: true)
            })
            
        } )
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

