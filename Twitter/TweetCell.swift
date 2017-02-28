//
//  TweetCell.swift
//  Twitter
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var numReplies: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var didRetweet: Bool = false
    var didFavorite: Bool = false
    
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onReply(_ sender: Any) {
        print("Reply button pressed")
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        let theTweetID = self.tweet!.tweetID
        
        if (self.tweet?.didRetweet)! {
            TwitterClient.sharedInstance?.unretweet(id: theTweetID, success: {
                print("Success, unretweeted")
                self.tweet?.retweetCount = (self.tweet?.retweetCount)! - 1
                self.numRetweets.text = String(self.tweet!.retweetCount)
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
                self.numRetweets.text = String(self.tweet!.retweetCount)
                
            }, failure: { (error) in
                print("Error with tweeting")
            })
            
            let retweetImage = UIImage(named: "retweet-icon-green")
            retweetButton.setImage(retweetImage, for: .normal)
            self.tweet?.didRetweet = true
        }
        
    }
    
    @IBAction func onLike(_ sender: Any) {
        let theTweetID = self.tweet!.tweetID
        
        if (self.tweet?.didFavorite)! {
            TwitterClient.sharedInstance?.unfavorite(id: theTweetID, success: {
                print("Success, unfavorited")
                self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! - 1
                self.numLikes.text = String(self.tweet!.favoritesCount)
            }, failure: { (error) in
                print("Error with unfavoriting")
            })
            
            let favImage = UIImage(named: "favor-icon.png")
            likeButton.setImage(favImage, for: .normal)
            self.tweet?.didFavorite = false
        }
        else {
            TwitterClient.sharedInstance?.favorite(id: theTweetID, success: {
                print("Success, favorited")
                self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! + 1
                self.numLikes.text = String(self.tweet!.favoritesCount)
            }, failure: { (error) in
                print("Error with favoriting")
            })
            
            let favImage = UIImage(named: "favor-icon-red.png")
            likeButton.setImage(favImage, for: .normal)
            self.tweet?.didFavorite = true
        }
    }

}
