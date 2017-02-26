//
//  TweetsViewController.swift
//  Twitter
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance!.homeTimeline(success: { (tweets: [Tweet]) -> ()  in
            self.tweets = tweets
            print("In TweetsViewController viewDidLoad")
          //  for tweet in tweets {
          //  print(tweet.text!)
          //  }
        }, failure: { (error: Error) -> () in
            print("Failed to get home timeline")
            //print(error.localizedDescription)
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
