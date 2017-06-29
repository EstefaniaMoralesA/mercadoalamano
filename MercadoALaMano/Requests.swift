//
//  Requests.swift
//  MercadoALaMano
//
//  Created by Estefania Morales Abud on 6/21/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import Foundation
import UIKit

class Requests {
    
    func verifySession(_ id: Int, token: String, result:@escaping (Bool)->())->URLSessionTask{

        let send = "cliente/verificarSesion/\(id)/\(token)"
        let request = Main.getStandardOnlyTextRequest(send, method: HTTPMethod.POST)
        return Main.performRequest(request as URLRequest) { (data, response, error) in
            
            func failVerification(){
                DispatchQueue.main.async{
                    result(false)
                }
            }
            
            if let error = error{
                
                print("Error while validating token\n\(error)\n\(#file):\(#line)")
                failVerification()
                return
            }
            
            guard let data = data else{
                print("Error while unwraping data\n\(#file):\(#line)")
                failVerification()
                return
            }
            
            do{
                
                let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                guard let dic = dictionary else{
                    
                    print("Error while unwraping dictionary\n\(#file):\(#line)")
                    failVerification()
                    return
                    
                }
                
                let validSession = dic["success"] as? Bool
                
                DispatchQueue.main.async{
                    result(validSession ?? false)
                }
                
            }
            catch{
                print("Error raised while parsing data\n\(String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue)))\(#file):\(#line)")
                failVerification()
                return
                
            }
        }
        
    }
}
