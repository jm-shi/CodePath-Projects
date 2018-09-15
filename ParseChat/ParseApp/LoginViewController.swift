//
//  LoginViewController.swift
//  ParseApp
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        signUp()
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        loginUser()
    }
    
    func signUp() {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                // Show the errorString somewhere and let the user try again.
            } else {
                // Let them use the app now.
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                print("Successfully signed up")
            }
        }
    }
    

    func loginUser() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                // Display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                print("User logged in successfully")
            }
        }
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
