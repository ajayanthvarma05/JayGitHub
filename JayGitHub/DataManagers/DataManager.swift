//
//  DataManager.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    public typealias UsersResult = (_ users: [User]?) -> ()
    public typealias RepoResult = (_ repos: [Repo]?) -> ()
    public typealias UserResult = (_ repos: User?) -> ()
    public typealias ImageResult = (_ image: UIImage?) -> ()
    
    //MARK: Users
    func getAllUsers(completion: @escaping UsersResult) {
        var request = URLRequest(url: URL(string: "https://api.github.com/users")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                //decode
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([User].self, from: data)
                completion(result)
            } catch {
                debugPrint("JSON Serialization error")
                completion([])
            }
        }).resume()
        
    }
    
    func get(user:String, completion: @escaping UserResult) {
        var request = URLRequest(url: URL(string: "https://api.github.com/users/\(user)")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                //decode
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(User.self, from: data)
                completion(result)
            } catch {
                debugPrint("JSON Serialization error")
                completion(nil)
            }
        }).resume()
    }
    
    //MARK: Repos
    func getRepo(user:String, completion: @escaping RepoResult) {
        var request = URLRequest(url: URL(string: "https://api.github.com/users/\(user)/repos?type=owner")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                //decode
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([Repo].self, from: data)
                completion(result)
            } catch {
                debugPrint("JSON Serialization error")
                completion(nil)
            }
        }).resume()
        
    }
    
}
