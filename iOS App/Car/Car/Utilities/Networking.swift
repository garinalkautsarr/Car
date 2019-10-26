//
//  Networking.swift
//  Home-Automation
//
//  Created by Manas Sharma on 26/09/19.
//  Copyright © 2019 Manas. All rights reserved.
//

import Foundation

struct Networking {
    private init(){}
    
    static func sendGETRequest(withURL url: URL, completion: @escaping (Result<Dictionary<String,Any>, Error>) -> Void){
        let urlSession = URLSession.shared
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        urlRequest.httpBody = nil
        urlRequest.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            var payload: Any? = nil
            if (200...205).contains(statusCode){
                guard let data = data else { return }
                do {
                    payload = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                }catch{
                    completion(.failure(error))
                    return
                }
                
                guard let payloadDictionary = payload as? Dictionary<String,Any> else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "The JSON isn't in the correct format. \(statusCode)"])))
                    return
                }
                completion(.success(payloadDictionary))
                
            }else{
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "An error occurred. \(statusCode)"])))
            }
        }
        task.resume()
    }
    
    static func sendPOSTRequest(withURL url: URL, withHTTPBody body: Any, completion: ((Result<Dictionary<String,Any>, Error>) -> Void)? = nil ){
        let urlSession = URLSession.shared
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
        urlRequest.httpMethod = "POST"
        var JSONPayload: Data? = nil
        do {
            JSONPayload = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }catch{
            completion?(.failure(error))
        }
        
        urlRequest.httpBody = JSONPayload
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion?(.failure(error))
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            var payload: Any? = nil
            
            if (200...205).contains(statusCode){
                guard let data = data else { return }
                do {
                    payload = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                }catch{
                    completion?(.failure(error))
                    return
                }
                
                guard let payloadDictionary = payload as? Dictionary<String,Any> else {
                    completion?(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "The JSON isn't in the correct format. \(statusCode)"])))
                    return
                }
                completion?(.success(payloadDictionary))
                
            }else{
                completion?(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "An error occurred. \(statusCode)"])))
            }
        }
        task.resume()
    }
}
