//
//  Repository.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 20/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import Foundation

struct Repository: Codable{
    let name: String?
    let stargazers_count: Int?
    let watchers_count: Int?
    let language: String?
    
    /// it list all repository from a user.
    ///
    /// - Parameters:
    ///   - completion: An array of repository. If the request fails it returns nil.
    static func list( repositoryUrl: String, completion: @escaping ( _ repositories: [Repository]?, _ errorMessage: String? ) -> Void ){
        ConectionManager.invoke(urlString: repositoryUrl , headerParameters: nil, completion: {
            data, urlResponse, error in
            if let _error = error{
                return completion(nil, _error.localizedDescription)
            }
            if let _data = data{
                do{
                    let repositories = try JSONDecoder().decode([Repository].self, from: _data)
                    completion(repositories, nil)
                }
                catch{
                    completion(nil, "Error to parse json.")
                }
            }
            else{ completion(nil, "Error to get data.") }
        })
    }
}
