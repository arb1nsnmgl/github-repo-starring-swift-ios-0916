//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatus(for user: GithubRepository, completion: @escaping (_ starred: Bool) -> ()) {
        
        
        GithubAPIClient.checkIfRepositoryIsStarred(user.fullName, with: { status in
            
            if status {
                GithubAPIClient.unstarRepository(named: user.fullName, completion: {
                    OperationQueue.main.addOperation {
                        completion(false)
                    }
                })
            } else {
                GithubAPIClient.starRepository(named: user.fullName, completion: {
                    OperationQueue.main.addOperation {
                        completion(true)
                    }
                })
            }
            
        })
        
    }
    
    
}
