//
//  CaptureViewController.swift
//  Instagram
//

import UIKit
import Parse

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var addImageLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(tapGestureRecognizer:)))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        photoImageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UIImagePickerController delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = pickedImage
            
            if self.photoImageView.image != nil {
                self.addImageLabel.isHidden = true
            }
            else {
                self.addImageLabel.isHidden = false
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectPhoto(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if self.photoImageView.image == nil {
            print("No photo was selected, could not submit")
            return
        }
        
        let imageToPost = resize(image: self.photoImageView.image!, newSize: CGSize(width: 200, height: 200))
        let captionToPost = self.captionTextField.text
        
        Post.postUserImage(image: imageToPost, withCaption: captionToPost) { (success: Bool, error: Error?) in
            if success {
                print("Submitted photo")
                self.tabBarController?.selectedIndex = 0
                self.photoImageView.image = nil
                self.captionTextField.text = ""
                self.addImageLabel.isHidden = false
            }
            else {
                print(error?.localizedDescription ?? "Error submitting photo")
            }
        }
    }

}
