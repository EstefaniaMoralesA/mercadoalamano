//
//  Usuario.swift
//  MercadoALaMano
//
//  Created by Estefania Morales Abud on 6/21/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class Usuario : NSObject, NSCoding{
    
    var nombre: String = ""
    var correo: String = ""
    var telefono: String = ""
    var id : Int = 0
    var pushToken: String?
    var session_token: String = ""
    var tipo: Int = 0;
    var password: String = ""
    fileprivate(set) var isCurrentUser : Bool = false
    
    
    fileprivate var statusChangeObservers = Array< ((Usuario, Bool)->(Bool)) >()
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(nombre, forKey: "name")
        aCoder.encode(correo, forKey: "email")
        aCoder.encode(telefono, forKey: "telephone")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(session_token, forKey: "session_token")
    }
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.nombre = aDecoder.decodeObject(forKey: "name") as! String
        self.correo = aDecoder.decodeObject(forKey: "email") as! String
        self.telefono =  (aDecoder.decodeObject(forKey: "telephone") as? String) ?? ""
        self.id = 1
        self.session_token = "399a1f57-43b0-4774-a37d-9d6beb63f9c0"
        
        self.isCurrentUser = true
        super.init()
        Usuario.currentUser = self
    }
    
    func logout(){
        if isCurrentUser{
            self.deleteUserInstance()
            
        }
    }
    
    init?(dictionary : NSDictionary, allowLogin : Bool){
        
        super.init()
        
        assignIfNotNil(&id, assignee: dictionary["_id"] as? Int)
        
        if allowLogin{
            assignIfNotNil(&session_token, assignee: dictionary["session_token"] as? String)
        }
        
        if !session_token.isEmpty{
            isCurrentUser = true
        }
        else{
            isCurrentUser = false
        }
        
        parseParamDictionary(dictionary)
        
        guard !nombre.isEmpty  && !correo.isEmpty else {
            
            deleteUserInstance()
            return nil
            
        }
        
    }
    
    func parseParamDictionary(_ dictionary : NSDictionary){
        
        assignIfNotNil(&nombre, assignee: dictionary["name"] as? String)
        assignIfNotNil(&correo, assignee: dictionary["email"] as? String)
        assignIfNotNil(&telefono, assignee: dictionary["telephone"] as? String)
        
        //TODO: actualizar imagen
        saveUserInstance()
    }
    
    fileprivate func saveUserInstance(){
        
        guard isCurrentUser else{
            return
        }
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userdata")
        NSKeyedArchiver.archiveRootObject([self] as NSArray, toFile: path)
        UserDefaults.standard.set(self.session_token, forKey: MercadoALaManoNSUserDefaultsKeys.User.rawValue)
        Usuario.currentUser = self
        
    }
    
    fileprivate func deleteUserInstance(){
        
        guard isCurrentUser else{
            return
        }
        
        UserDefaults.standard.removeObject(forKey: MercadoALaManoNSUserDefaultsKeys.User.rawValue)
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userdata")
        _ = try? FileManager.default.removeItem(atPath: path)
        Usuario.currentUser = nil
        
    }
    
    static fileprivate(set) var currentUser : Usuario?
    
    
    override var hashValue: Int {
        get{
            return self.id.hashValue
        }
    }
}


