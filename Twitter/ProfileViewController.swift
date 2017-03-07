//
//  ProfileViewController.swift
//  Twitter
//
//  Created by admin on 3/6/17.
//  Copyright © 2017 JS. All rights reserved.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
