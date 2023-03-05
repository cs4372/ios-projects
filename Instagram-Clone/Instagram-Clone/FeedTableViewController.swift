//
//  FeedTableViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 3/4/23.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    var users = [String: String]()
    var followings = [String]()
    var comments = [String]()
    var images = [PFFileObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let following = PFQuery(className:"Following")
        following.whereKey("follower", equalTo: PFUser.current()?.objectId)
        following.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let followers = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects) scores.")
                // Do something with the found objects
                //                let following = PFQuery(className:"Post")
                
                print("objects", objects)
                for follower in followers {
                    if let followedUser = follower["following"] {
                        let query = PFQuery(className:"Post")
                        query.whereKey("userId", equalTo: followedUser)
                        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                            if let error = error {
                                
                            } else if let posts = objects {
                                print("post224", posts)
                                for post in posts {
                                    if let userId = post["userId"] {
                                        self.followings.append(userId as! String)
                                    }
                                    if let comment = post["imageName"] {
                                        self.comments.append(comment as! String)
                                    }
                                    if let image = post["imageFile"] {
                                        self.images.append(image as! PFFileObject)
                                    }
                                    self.tableView.reloadData()
                                }
                                print("followings ==>", self.followings)
                                print("comments ==>", self.comments)
                                print("images ==>", self.images)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        let userImageFile = images[indexPath.row]
        userImageFile.getDataInBackground {(imageData, error) in
            if let error = error {
                print("inside error", error.localizedDescription)
            } else if let data = imageData {
                if let image = UIImage(data:data) {
                    cell.userImage.image = image
                }
            }
        }
        cell.userComment.text = comments[indexPath.row]
        cell.userInfo.text = followings[indexPath.row]
        print("cell ==>", cell)
        return cell
    }
    
}
