//
//  TweetDetailsViewController.swift
//  Twitter
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.tweet?.didRetweet)! {
            let retweetImage = UIImage(named: "retweet-icon-green.png")
            retweetButton.setImage(retweetImage, for: .normal)
            self.tweet?.didRetweet = true
        }
        else {
            let retweetImage = UIImage(named: "retweet-icon.png")
            retweetButton.setImage(retweetImage, for: .normal)
            self.tweet?.didRetweet = false
        }
        
        if (self.tweet?.didFavorite)! {
            let favImage = UIImage(named: "favor-icon-red.png")
            favoritesButton.setImage(favImage, for: .normal)
            self.tweet?.didFavorite = true
        }
        else {
            let favImage = UIImage(named: "favor-icon.png")
            favoritesButton.setImage(favImage, for: .normal)
            self.tweet?.didFavorite = false
        }
        
        profileImage.setImageWith((self.tweet?.currentUser?.profileUrl)!)
        nameLabel.text = self.tweet?.name
        usernameLabel.text = self.tweet?.username
        tweetLabel.text = self.tweet?.text
        timestampLabel.text = self.tweet?.detailsTimeAsString
        retweetCountLabel.text = self.tweet?.retweetCountAsString
        favoritesCountLabel.text = self.tweet?.favoritesCountAsString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onRetweet(_ sender: Any) {
        let theTweetID = self.tweet!.tweetID
        
        if (self.tweet?.didRetweet)! {
            TwitterClient.sharedInstance?.unretweet(id: theTweetID, success: {
                print("Success, unretweeted")
                self.tweet?.retweetCount = (self.tweet?.retweetCount)! - 1
                self.retweetCountLabel.text = String(self.tweet!.retweetCount)
            }, failure: { (error) in
                print("Error with unretweeting")
            })
            
            let retweetImage = UIImage(named: "retweet-icon.png")
            retweetButton.setImage(retweetImage, for: .normal)
            self.tweet?.didRetweet = false
        }
        else {
            TwitterClient.sharedInstance?.retweet(id: theTweetID, success: {
                print("Success, retweeted")
                self.tweet?.retweetCount = (self.tweet?.retweetCount)! + 1
                self.retweetCountLabel.text = String(self.tweet!.retweetCount)
                
            }, failure: { (error) in
                print("Error with tweeting")
            })
            
            let retweetImage = UIImage(named: "retweet-icon-green")
            retweetButton.setImage(retweetImage, for: .normal)
            self.tweet?.didRetweet = true
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        let theTweetID = self.tweet!.tweetID
        
        if (self.tweet?.didFavorite)! {
            TwitterClient.sharedInstance?.unfavorite(id: theTweetID, success: {
                print("Success, unfavorited")
                self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! - 1
                self.favoritesCountLabel.text = String(self.tweet!.favoritesCount)
            }, failure: { (error) in
                print("Error with unfavoriting")
            })
            
            let favImage = UIImage(named: "favor-icon.png")
            favoritesButton.setImage(favImage, for: .normal)
            self.tweet?.didFavorite = false
        }
        else {
            TwitterClient.sharedInstance?.favorite(id: theTweetID, success: {
                print("Success, favorited")
                self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! + 1
                self.favoritesCountLabel.text = String(self.tweet!.favoritesCount)
            }, failure: { (error) in
                print("Error with favoriting")
            })
            
            let favImage = UIImage(named: "favor-icon-red.png")
            favoritesButton.setImage(favImage, for: .normal)
            self.tweet?.didFavorite = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.tweet = tweet
        }
    }

}
