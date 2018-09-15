//
//  TweetsViewController.swift
//  Twitter
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    var tweets: [Tweet]!
    var loadingMoreView: InfiniteScrollActivityView?
    var isMoreDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.53, green: 0.79, blue: 0.99, alpha: 0.9)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let titleTextColor: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextColor as? [String : Any]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        TwitterClient.sharedInstance?.homeTimeline(max_id: 0, success: { (tweets: [Tweet])  in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        User.currentUser = nil
        TwitterClient.sharedInstance?.logout()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadMoreTweets(lastTweetID: 0)
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Load more tweets
                let lastTweetID = tweets[tweets.endIndex-1].tweetID-1
                loadMoreTweets(lastTweetID: lastTweetID)
            }
        }
    }
    
    func loadMoreTweets(lastTweetID: Int) {
        TwitterClient.sharedInstance?.homeTimeline(max_id: lastTweetID, success: { (tweets: [Tweet])  in
            self.isMoreDataLoading = false
            self.tweets.append(contentsOf: tweets)
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
            let retweetImage = UIImage(named: "retweet-icon.png")
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
