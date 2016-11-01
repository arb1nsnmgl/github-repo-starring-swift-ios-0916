//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(_ fullName: String, with completion: @escaping (Bool) -> ()) {
        
        let url  = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.personalToken)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                 print("RESPONSE : \(response.statusCode)")
                if response.statusCode == 204 {
                    OperationQueue.main.addOperation {
                        completion(true)
                    }
                } else if response.statusCode == 404 {
                    OperationQueue.main.addOperation {
                        completion(false)
                    }
                }
            }
        })
        task.resume()
        
    }
    
    class func starRepository(named: String, completion: @escaping () -> ()) {
        
        let url  = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(named)?access_token=\(Secrets.personalToken)")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    OperationQueue.main.addOperation {
                        completion()
                    }
                } else if response.statusCode == 404 {
                    OperationQueue.main.addOperation {
                        completion()
                    }
                }
            }
        })
        task.resume()
        
    }
    
    class func unstarRepository(named: String, completion: @escaping () -> ()) {
        
        let url  = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(named)?access_token=\(Secrets.personalToken)")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    OperationQueue.main.addOperation {
                        completion()
                    }
                } else if response.statusCode == 404 {
                    OperationQueue.main.addOperation {
                        completion()
                    }
                }
            }
        })
        task.resume()
        
    }
   
}

