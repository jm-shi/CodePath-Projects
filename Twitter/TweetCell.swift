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
        print("Tweet id is")
        print(self.tweet?.tweetID)
        
        TwitterClient.sharedInstance?.retweet(id: self.tweet!.tweetID, success: {
            print("Success")
            self.tweet?.retweetCount = (self.tweet?.retweetCount)! + 1
        }, failure: { (error) in
            print("Error")
        })
        
        if didRetweet {
            let retweetImage = UIImage(named: "retweet-icon.png")
            retweetButton.setImage(retweetImage, for: .normal)
            retweetCount = retweetCount - 1
            didRetweet = false
        }
        else {
            let retweetImage = UIImage(named: "retweet-icon-green")
            retweetButton.setImage(retweetImage, for: .normal)
            retweetCount = retweetCount + 1
            didRetweet = true
        }
        
        //numRetweets.text = String(retweetCount)
    }
    
    @IBAction func onLike(_ sender: Any) {
        print("Like button pressed")
        
        if didFavorite {
            let favImage = UIImage(named: "favor-icon.png")
            likeButton.setImage(favImage, for: .normal)
            favoritesCount = favoritesCount - 1
            didFavorite = false
        }
        else {
            let favImage = UIImage(named: "favor-icon-red")
            likeButton.setImage(favImage, for: .normal)
            favoritesCount = favoritesCount + 1
            didFavorite = true
        }
        
        numLikes.text = String(favoritesCount)
    }

}
