//
//  TwitterClient.swift
//  Twitter
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "oJCqiq7i2e53cOni42EfYSIt8", consumerSecret: "bPlTNY8EqpkKx2J21WH472F1LZCehxCEOY5h5ZWrKZAv8aW3Xh")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitter://oauth")!, scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in

            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        }, failure: {(error: Error?) -> Void in
            print("Error: \(error!.localizedDescription)")
            self.loginFailure!(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) in
            print("Error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(max_id: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        var link = "1.1/statuses/home_timeline.json"
        if max_id != 0 {
            link = link + "?max_id=\(max_id)"
        }
        
        get(link, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func composeTweet(tweetText: String, params: NSDictionary?, completion: @escaping (_ error: Error?) -> ()) {
        self.post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Tweeted")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Could not compose tweet")
            completion(error as Error?)
        })
    }
    
    func retweet(id: Int, success: @escaping () -> (),
                 failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: nil, progress:
            nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func unretweet(id: Int, success: @escaping () -> (),
                 failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/statuses/unretweet/\(id).json", parameters: nil, progress:
            nil, success: { (task, response) in
                success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func favorite(id: Int, success: @escaping () -> (),
                 failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/favorites/create.json?id=\(id)", parameters: nil, progress:
            nil, success: { (task, response) in
                success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func unfavorite(id: Int, success: @escaping () -> (),
                  failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress:
            nil, success: { (task, response) in
                success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }

}
