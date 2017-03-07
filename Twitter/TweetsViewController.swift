//
//  TweetsViewController.swift
//  Twitter
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.53, green: 0.79, blue: 0.99, alpha: 0.9)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let titleTextColor: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextColor as? [String : Any]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet])  in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        
        getHomeTimeline()
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

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getHomeTimeline()
        refreshControl.endRefreshing()
    }
    
    func getHomeTimeline() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet])  in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: UITableViewDelegate and UITableViewDataSource
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

        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        let tweet = tweets[indexPath.row]
        
        cell.profileImage.setImageWith((tweet.currentUser?.profileUrl)!)
        
        cell.tweet = tweet
        
        let replyImage = UIImage(named: "reply-icon.png")
        cell.replyButton.setImage(replyImage, for: .normal)
        
        if tweet.didRetweet {
            let retweetImage = UIImage(named: "retweet-icon-green.png")
            cell.retweetButton.setImage(retweetImage, for: .normal)
            tweet.didRetweet = true
        }
        else {
            let retweetImage = UIImage(named: "retweet-icon.png")
            cell.retweetButton.setImage(retweetImage, for: .normal)
            tweet.didRetweet = false
        }
        
        if tweet.didFavorite {
            let favImage = UIImage(named: "favor-icon-red.png")
            cell.likeButton.setImage(favImage, for: .normal)
            tweet.didFavorite = true
        }
        else {
            let favImage = UIImage(named: "favor-icon.png")
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! UITableViewCell
                let indexPath = self.tableView.indexPath(for: cell)
                let tweet = tweets[(indexPath?.row)!]
                let profileViewController = segue.destination as! ProfileViewController
                profileViewController.tweet = tweet
            }
        }
        else if segue.identifier == "composeSegue" {
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.user = User.currentUser
        }
        else if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let tweetsDetailViewController = segue.destination as! TweetDetailsViewController
            tweetsDetailViewController.tweet = tweets[(indexPath?.row)!]
        }
    }
    
}
