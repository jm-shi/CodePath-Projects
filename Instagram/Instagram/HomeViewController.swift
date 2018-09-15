//
//  HomeViewController.swift
//  Instagram
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.29, green: 0.44, blue: 0.7, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        query.order(byDescending: "createdAt")
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error fetching images")
            }
        }
        
        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(HomeViewController.onTimer), userInfo: nil, repeats: false)
        refreshEveryFiveSeconds()
    }
    
    // MARK: TableView delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (posts?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        let post = posts?[indexPath.row]
        
        let photo = post?["media"] as! PFFile
        photo.getDataInBackground {(data: Data?, error: Error?) in
            if error == nil {
                cell.photoImageView.image = UIImage(data: data!)
            }
        }
        
        cell.instagramPost = self.posts?[indexPath.row]
        
        let author = post?["author"] as! PFUser
        cell.usernameLabel.text = String(describing: author.username!)
        
        let timestamp = post?.createdAt
        cell.timestampLabel.text = String(describing: formatTimestamp(date: timestamp!))
        
        cell.captionLabel.text = post?["caption"] as? String
              
        if let userProfileImage = author.object(forKey: "userProfileImage") as? PFFile {
            userProfileImage.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.profilePicImageView.image = image
                }
            })
        }
        
        return cell
    }
    
    // MARK: Actions
    func formatTimestamp(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let timestamp = dateFormatter.string(from: date)
        return timestamp
    }
    
    func refreshEveryFiveSeconds() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.onTimer), userInfo: nil, repeats: true)
    }
    
    func onTimer() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.findObjectsInBackground { (updatedPosts: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.posts = updatedPosts
                self.tableView.reloadData()
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
}
