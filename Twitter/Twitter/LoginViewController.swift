//
//  LoginViewController.swift
//  Twitter
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let client = TwitterClient.sharedInstance
        
        client?.login(success: { () -> () in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) {(error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }

}
