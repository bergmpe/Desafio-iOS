//
//  User.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 19/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import Foundation
import UIKit

class User: Codable{
    
    let avatar_url: String?
    let events_url: String?
    let followers_url: String?
    let following_url: String?
    let gists_url: String?
    let gravatar_id: String?
    let html_url: String?
    let id: Int?
    let login: String?
    let node_id: String?
    let organizations_url: String?
    let received_events_url: String?
    let repos_url: String?
    let site_admin: Bool?
    let starred_url: String?
    let subscriptions_url: String?
    let type: String?
    let url: String?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let public_repos: Int?
    let public_gists: Int?
    let followers: Int?
    let following: Int?
    let created_at: String?
    let updated_at: String?
    
    var imageData: Data?
    
    static var offSet : String? = "0"
    
    func getImageData(completion: @escaping (_ imageData: Data?) -> Void ){
        if let _imageData = imageData{
            return completion( _imageData )
        }
        guard let urlString = avatar_url, let url = URL(string: urlString) else {
            return completion(nil)
        }
        ConectionManager.requestData(url: url, completion: {
            data, urlResponse, error in
            if let _data = data{
                self.imageData = _data
                completion( _data )
            }
            else{
                completion(nil)
            }
        })
    }
    
    func getRepositories(){
        guard let repositoryUrl = repos_url else {
            return
        }
        ConectionManager.invoke(urlString: repositoryUrl, headerParameters: nil, completion: {
            data, urlResponse, error in
            print(data)
        })
    }
    
    /// it list all users from github.
    ///
    /// - Parameters:
    ///   - completion: An array of users. If the request fails it returns nil.
    class func list( completion: @escaping ( _ users: [User]?, _ errorMessage: String? ) -> Void ){
        ConectionManager.invoke(service: "users?since=" + (offSet ?? "0"), headerParameters: nil, completion: {
            data, urlResponse, error in
            if let _error = error{
                return completion(nil, _error.localizedDescription)
            }
            if let _data = data, let _urlResponse = urlResponse{
                do{
                    let httpResponse = _urlResponse as! HTTPURLResponse
                    let linkHeaderResponse = httpResponse.allHeaderFields["Link"] as! String
                    if let _link = linkHeaderResponse.split(separator: ";").filter({ $0.contains("since=") }).first{
                        let linkString = String(_link).replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
                        offSet = String(linkString.split(separator: "=").last ?? "0" )
                    }
                    let users = try JSONDecoder().decode([User].self, from: _data)
                    completion(users, nil)
                }
                catch{
                    completion(nil, "Error to parse json.")
                }
            }
            else{ completion(nil, "Error to get data.") }
        })
    }
    
    /// it gets an specific user.
    ///
    /// - Parameters:
    ///   - userLogin: the user login.
    ///   - completion: The user from github. If the request fails or the do not exists returns nil.
    class func getDetail(userLogin: String, completion: @escaping (_ user: User?) -> Void){
        ConectionManager.invoke(service: "users/" + userLogin, headerParameters: nil, completion: {
            data, urlResponse, error in
            if let _data = data{
                do{
                    let json = try JSONDecoder().decode(User.self, from: _data)
                    completion(json)
                }
                catch{
                    print("Deu ruim")
                    completion(nil)
                }
            }
        })
    }
    
}
