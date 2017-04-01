//
//  ProfileViewController.swift
//  Twitter
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let backgroundURL = self.tweet?.currentUser?.backgroundUrl! {
            self.backgroundImage.setImageWith(backgroundURL)
        }
        
        if let profileURL = self.tweet?.currentUser?.profileUrl! {
            self.profileImage.setImageWith(profileURL)
        }
        
        self.nameLabel.text = self.tweet?.currentUser?.name
        self.usernameLabel.text = "@" + (self.tweet?.currentUser?.screenname)!
        
        self.tweetCount.text = String(describing: (self.tweet?.currentUser?.tweetsCount)!)
        self.followingCount.text = String(describing: (self.tweet?.currentUser?.followingCount)!)
        self.followersCount.text = String(describing: (self.tweet?.currentUser?.followersCount)!)
        
    }

}
