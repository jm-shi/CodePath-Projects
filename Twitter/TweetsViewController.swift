//
//  TweetsViewController.swift
//  Twitter
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet])  in
            self.tweets = tweets
            
          //  for tweet in tweets {
          //      print(tweet.text!)
          //  }
            
            self.tableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        User.currentUser = nil
        TwitterClient.sharedInstance?.logout()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell

        let tweet = tweets[indexPath.row]
        
        cell.profileImage.setImageWith((tweet.currentUser?.profileUrl)!)
        
        let replyImage = UIImage(named: "reply-icon")
        cell.replyButton.setImage(replyImage, for: .normal)
        
        if tweet.didRetweet {
            let retweetImage = UIImage(named: "retweet-icon-green")
            cell.retweetButton.setImage(retweetImage, for: .normal)
            tweet.didRetweet = true
        }
        else {
            let retweetImage = UIImage(named: "retweet-icon")
            cell.retweetButton.setImage(retweetImage, for: .normal)
            tweet.didRetweet = false
        }
        
        if tweet.didFavorite {
            let favImage = UIImage(named: "favor-icon-red")
            cell.likeButton.setImage(favImage, for: .normal)
            tweet.didFavorite = true
        }
        else {
            let favImage = UIImage(named: "favor-icon")
            cell.likeButton.setImage(favImage, for: .normal)
            tweet.didFavorite = false
        }

        cell.tweetLabel.text = tweet.text
        cell.nameLabel.text = tweet.name
        cell.usernameLabel.text = tweet.username
        cell.timestampLabel.text = tweet.timeSinceAsString
        
        cell.numRetweets.text = String(tweet.retweetCount)
        cell.numLikes.text = String(tweet.favoritesCount)
        
        return cell
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
