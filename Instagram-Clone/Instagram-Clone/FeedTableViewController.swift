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
    var postIds = [String]()
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
                for follower in followers {
                    if let followedUser = follower["following"] {
                        let query = PFQuery(className:"Post")
                        query.whereKey("userId", equalTo: followedUser)
                        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                            if let error = error {
                                
                            } else if let posts = objects {
                                for post in posts {
                                    self.postIds.append(post.objectId as! String)
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
        return cell
    }
    
    @IBAction func likePost(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        print("button is in row \(indexPath.row)")
        
        // check if user has already liked the current post
        let query = PFQuery(className:"Like")
        query.whereKey("user_id", equalTo: PFUser.current()?.objectId)
        query.whereKey("post_id", equalTo: self.postIds[indexPath.row])
        

        query.findObjectsInBackground(block: {( objects, error) in
            if let objects = objects {
                if objects.count > 0 {
                    // TODO: user  has already liked the post so unlike it
//                        for obj in objects {
//                            obj.deleteInBackground()
//                        }
                } else {
                    // TODO: user hasn't liked the post yet, so like it and increase count
                    let userLike = PFObject(className: "Like")
                    userLike["user_id"] = PFUser.current()?.objectId
                    userLike["post_id"] = self.postIds[indexPath.row]
                    userLike.saveInBackground {(succeeded, error) in
                        if (succeeded) {
                            print("save like")
                        } else {
                            print("error saving like")
                        }
                    }
                }
            }
            
        })
        
         //get like object and query number of post_ids, then update
        let likeQuery = PFQuery(className:"Like")
        likeQuery.whereKey("post_id", equalTo: self.postIds[indexPath.row])
        likeQuery.findObjectsInBackground(block: {( objects, error) in
            if let objects = objects {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
                print("====>count", objects.count)
                DispatchQueue.main.async {
                    cell.likesCount.text = String(objects.count)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func getPostLikes() {
        
    }
}
