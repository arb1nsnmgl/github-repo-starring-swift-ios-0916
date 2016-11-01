//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = store.repositories[indexPath.row]
        
        store.toggleStarStatus(for: repository, completion: { status in
           self.showAlert(status: status, user: repository.fullName )
        })
        
    }
    
    func showAlert(status: Bool, user: String) {
        
        let message : String
        if status {
            message = "You just starred \(user)"
        } else {
            message = "You just unstarred \(user)"
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
 
    }
    
    
    
   
}
