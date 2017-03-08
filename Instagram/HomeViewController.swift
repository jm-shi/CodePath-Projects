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
        
        let query = PFQuery(className: "Post")
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error fetching images")
            }
        }
        
        refreshEveryFiveSeconds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        
        cell.captionLabel.text = post?["caption"] as? String
        
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func refreshEveryFiveSeconds() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.onTimer), userInfo: nil, repeats: true)
    }
    
    func onTimer() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        
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
