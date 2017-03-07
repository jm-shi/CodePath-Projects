//
//  ComposeViewController.swift
//  Twitter
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profileURL = self.user.profileUrl {
            self.profileImage.setImageWith(profileURL)
        }
        
        self.nameLabel.text = self.user.name
        self.usernameLabel.text = "@" + (self.user.screenname)!
        
        let tweetButton = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(self.onTweet))
        self.navigationItem.rightBarButtonItem = tweetButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTweet() {
     //   let tweetText = tweetTextView.text
     //   let paramsDictionary: NSDictionary = NSDictionary(dictionary: ["status": tweetText!])
     //   TwitterClient.sharedInstance?.composeTweet(tweetText: tweetText!, params: paramsDictionary, completion: { (error) in
     //       print(error?.localizedDescription ?? "")
     //   })
        _ = navigationController?.popViewController(animated: true)
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
