//
//  UserTableViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 3/2/23.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.findObjectsInBackground(block: {(users, error) in
            if error != nil {
                
            } else if let users = users {
                for obj in users {
                    if let user = obj as? PFUser {
                        if let username = user.username {
                            self.usernames.append(username)
                        }
                    }
                }
            }
        })
        self.tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        var currentUser = PFUser.current()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = "Test"
        return cell!
    }
}
