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
    var likes = [Bool]()
    
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
        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        return cell
    }
    
    func isPostLiked() {
        
    }
    
    @IBAction func likePost(sender: UIButton) {
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
        let feedTableViewCell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell

        print("button is in row \(indexPath.row)")
        
        //check if user has already liked the current post
        let query = PFQuery(className:"Like")
        query.whereKey("user_id", equalTo: PFUser.current()?.objectId)
        query.whereKey("post_id", equalTo: self.postIds[indexPath.row])

        query.findObjectsInBackground(block: {( objects, error) in
            if let objects = objects {
                if objects.count > 0 {
                    // TODO: user  has already liked the post so unlike it
                        for obj in objects {
                            if let isLiked = obj["isLiked"]! as? Bool {
                                if (isLiked) {
                                    obj["isLiked"] = false
                                    feedTableViewCell?.likeButton.tintColor = .systemPink
                                    feedTableViewCell?.likeButton.setImage(UIImage(named: "heart"), for: .normal)
                                } else {
                                    obj["isLiked"] = true
                                    feedTableViewCell?.likeButton.tintColor = .systemBlue
                                    feedTableViewCell?.likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
                                }
                            }
                            obj.saveInBackground()
                        }
                } else {
                    // TODO: user hasn't liked the post yet, so like it and increase count
                    let userLike = PFObject(className: "Like")
                    userLike["user_id"] = PFUser.current()?.objectId
                    userLike["post_id"] = self.postIds[indexPath.row]
                    userLike["isLiked"] = false
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
    }
}
