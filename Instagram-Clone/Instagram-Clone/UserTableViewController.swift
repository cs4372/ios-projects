//
//  UserTableViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 3/2/23.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [String]()
    var objectIds = [String]()
    var followings = [String:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        query?.findObjectsInBackground(block: {(users, error) in
            if error != nil {
                
            } else if let users = users {
                for obj in users {
                    print("user", obj)
                    if let user = obj as? PFUser {
                        if let username = user.username {
                            if let objectId = user.objectId {
                                self.usernames.append(username)
                                self.objectIds.append(objectId)
                                
                                let query = PFQuery(className:"Following")
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                                query.whereKey("following", equalTo: objectId)
                                query.findObjectsInBackground(block: {(objects, err) in
                                    if let objects = objects {
                                        if objects.count > 0 {
                                            self.followings[objectId] = true
                                        } else {
                                            self.followings[objectId] = false
                                        }
                                        self.tableView.reloadData()
                                    }
                                })
                            }
                        }
                    }
                }
            }
        })
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
        return usernames.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = usernames[indexPath.row]
        if let followingBool = followings[objectIds[indexPath.row]] {
            if followingBool {
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        } else {
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(followings[objectIds[indexPath.row]])
        if let followingsBool = followings[objectIds[indexPath.row]] {
            if followingsBool {
                cell?.accessoryType = UITableViewCell.AccessoryType.none
                followings[objectIds[indexPath.row]] = false
                let following = PFQuery(className:"Following")
                following.whereKey("follower", equalTo: PFUser.current()?.objectId)
                following.whereKey("following", equalTo: objectIds[indexPath.row])
                following.findObjectsInBackground(block: {(objects, err) in
                    if let objects = objects {
                        for obj in objects {
                            obj.deleteInBackground()
                        }
                    }
                })
            }
         else {
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            followings[objectIds[indexPath.row]] = true
            let following = PFObject(className:"Following")
            following["follower"] = PFUser.current()?.objectId
            following["following"] = objectIds[indexPath.row]
             following.saveInBackground { (succeeded, error)  in
                 if (succeeded) {
                     print("following created!")
                 } else {
                     print("error selecting row")
                 }
                }  
            }
        }
    }
}

