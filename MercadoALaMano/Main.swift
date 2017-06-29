//
//  Main.swift
//  MercadoALaMano
//
//  Created by Estefania Morales Abud on 6/21/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import Foundation
import UIKit

class Main{
    
    class fileprivate func getURL() -> String{
        return "https://mercadoalamano.azurewebsites.net/api"
    }
    
    class func getStandardOnlyTextRequest(_ site : String, method : HTTPMethod = .GET,  httpdata: String? = nil)->NSMutableURLRequest{
        
        let request = getStandardRequest(site, method: method)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let requestBody = httpdata{
            request.httpBody = requestBody.data(using: String.Encoding.utf8)
        }
        
        return request
    }
    
    class fileprivate func getStandardRequest(_ site : String, method : HTTPMethod = .GET )->NSMutableURLRequest{
        
        let stringUrl = "\(Main.getURL())/\(site)"
        let url: URL = URL(string: stringUrl)!
        #if DEBUG
            print("Requested URL \(url)")
        #endif
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 8
        return request
    }
    
    class func getDictionaryForRequest(_ request : NSMutableURLRequest, callback : @escaping (NSDictionary?)->() ){
        
        func functionFail(){
            
            DispatchQueue.main.async{
                callback(nil)
            }
            
        }
        
        Main.performRequest(request as URLRequest, result: {
            
            (data, response, error) in
            
            if let error = error{
                
                functionFail()
                print("\(error)\n\(#file):\(#line)")
                return
                
            }
            
            guard let data = data else{
                
                functionFail()
                print("Error. Data was nil.\n\(#file):\(#line)")
                return
                
            }
            
            let optionalDictionary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            if let dictionary = optionalDictionary{
                
                DispatchQueue.main.async{
                    callback(dictionary)
                }
                
            }
            else{
                
                functionFail()
                print("Error. Data was not parsed.\n\(String(describing: NSString(data:data, encoding: String.Encoding.utf8.rawValue)))\n\(#file):\(#line)")
                
            }
            
        })
        
    }
    
    class func performRequest(_ request : URLRequest, result : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?)->() )->URLSessionTask{
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            
            d, r, e in
            
            DispatchQueue.main.async{
                result(d, r, e as NSError?)
            }
            
        })
        
        task.resume()
        return task
        
    }
    
    class func performRequest(_ request : NSMutableURLRequest, result : @escaping (Bool, String?)->()){
        
        Main.getDictionaryForRequest(request) {
            
            (dictionary) in
            
            if dictionary == nil{
                result(false, "Error desconocido vuelva a intentarlo")
            }
            else{
                
                let success = dictionary!["success"] as? Bool
                
                if let successUnwrapped = success{
                    
                    if !successUnwrapped{
                        result(false, dictionary!["mensaje"] as? String)
                        print("\(String(describing: dictionary!["mensaje"]))\n\(#file):\(#line)")
                        return
                    }
                    
                    result(true, nil)
                    
                }
                    
                else{
                    
                    print("Dictionary did not contained success flag\n \(#file):\(#line)")
                    result(false, "Error desconocido, vuelva a intentarlo")
                    
                }
                
            }
            
        }
    }
}

public enum HTTPMethod : String{
    
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case GET = "GET"
    
}
