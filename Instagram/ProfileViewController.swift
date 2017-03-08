//
//  ProfileViewController.swift
//  Instagram
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            print("Logging out")
            self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
        }
    }

}
