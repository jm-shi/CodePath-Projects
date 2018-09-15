//
//  ProfileViewController.swift
//  Instagram
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editProfilePicButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.29, green: 0.44, blue: 0.7, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.logoutButton.tintColor = UIColor.white
        self.editProfilePicButton.layer.cornerRadius = 5
        
        let currentUsername = currentUser?["username"]!
        usernameLabel.text = "  " + String(describing: currentUsername!)
        
        if let userProfileImage = currentUser?.object(forKey: "userProfileImage") as? PFFile {
            userProfileImage.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.photoImageView.image = image
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIImagePickerController delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.photoImageView.image = pickedImage
        }
        updateProfilePic()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            print("Logging out")
            self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
        }
    }
    
    @IBAction func onEditProfilePic(_ sender: Any) {
        print("Changing profile picture")
        selectPhoto()
    }
    
    func selectPhoto() {
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updateProfilePic() {
        if self.photoImageView.image == nil {
            return
        }
        
        let profileImage = self.photoImageView!.image
        let profileImageFile = Post.getPFFileFromImage(image: profileImage)
        
        currentUser?.setObject(profileImageFile!, forKey: "userProfileImage")
        currentUser?.saveInBackground(block: { (saved: Bool, error: Error?) in
            if saved {
                print("Saved profile image")
            }
            else {
                print("Failed to save profile image: \(error)")
            }
        })
    }

}
