//
//  Tweet.swift
//  Twitter
//

import UIKit

class Tweet: NSObject {

    var currentUser: User?
    var text: String?
    var name: String?
    var username: String?
    var timestamp: Date?
    
    var tweetID: Int = 0
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var didRetweet: Bool
    var didFavorite: Bool
    var retweetCountAsString: String?
    var favoritesCountAsString: String?
    
    var timeSince: Int = 0
    var timeSinceAsString: String?
    var detailsTimeAsString: String?
    
    let minute: Int = 60
    let hour: Int = 3600
    let day: Int = 86400
    
    init(dictionary: NSDictionary)
    {
        currentUser = User(dictionary: dictionary["user"] as! NSDictionary)
        name = currentUser?.name
        username = "@" + (currentUser?.screenname)!
        
        text = dictionary["text"] as? String
        
        tweetID = dictionary["id"] as! Int
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweetCountAsString = String(retweetCount)
        favoritesCountAsString = String(favoritesCount)
        
        didRetweet = dictionary["retweeted"] as! Bool
        didFavorite = dictionary["favorited"] as! Bool
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as Date?
            
            formatter.dateFormat = "h:mm a - d MMM y"
            detailsTimeAsString = formatter.string(from: timestamp!);
            
            timeSince = Int(Date().timeIntervalSince(timestamp!))

            if (timeSince < minute) {
                timeSinceAsString = String(timeSince) + "s ago"
            }
            else if (timeSince < hour) {
                timeSinceAsString = String(timeSince/minute) + "m ago"
            }
            else if (timeSince < day) {
                if (timeSince/hour == 1) {
                    timeSinceAsString = String(timeSince/hour) + "hr ago"
                }
                else {
                    timeSinceAsString = String(timeSince/hour) + "hrs ago"
                }
            }
            else {
                let numDaysAgo = timeSince/day
                if (numDaysAgo == 1) {
                    timeSinceAsString = String(timeSince/day) + "day ago"
                }
                else {
                    if (numDaysAgo < 365) {
                        timeSinceAsString = String(timeSince/day) + "days ago"
                    }
                    else {
                        let numYearsAgo = numDaysAgo/365
                        timeSinceAsString = String(numYearsAgo) + "years ago"
                    }
                }
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
