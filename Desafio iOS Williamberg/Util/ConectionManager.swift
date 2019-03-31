//
//  ConectionManager.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 19/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import Foundation

class ConectionManager{
    
    private static let rootEndpoint = "https://api.github.com/"
    
    class func invoke(service:String, headerParameters: [String: String]? ,completion: @escaping  ( _ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void ){
        
        guard let url = URL(string: rootEndpoint + service) else{ return }
        var request = URLRequest(url: url)
        request.setValue("bergmpe", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if let _headerParameter = headerParameters{
            _headerParameter.forEach({
                parameter in
                request.setValue(parameter.key, forHTTPHeaderField: parameter.value)
            })
        }
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: {
            data, urlResponse, error in
            completion(data, urlResponse, error)
        })
        dataTask.resume()
    }
    
    class func invoke(urlString: String, headerParameters: [String: String]? ,completion: @escaping  ( _ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void ){
        
        guard let url = URL(string: urlString) else{ return }
        var request = URLRequest(url: url)
        request.setValue("bergmpe", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if let _headerParameter = headerParameters{
            _headerParameter.forEach({
                parameter in
                request.setValue(parameter.key, forHTTPHeaderField: parameter.value)
            })
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            data, urlResponse, error in
            completion(data, urlResponse, error)
        }).resume()
    }
    
    class func requestData(url: URL, completion: @escaping ( _ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("bergmpe", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            data, urlResponse, error in
            completion(data, urlResponse, error)
        }).resume()
    }
}
