//
//  ChatViewController.swift
//  ParseApp
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject]?
    var usernames: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshEverySecond()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSend(_ sender: Any) {
        saveMessage()
    }
    
    func saveMessage() {
        let theText = PFObject(className:"Message")
        theText["text"] = messageTextField.text
        theText["user"] = PFUser.current() ?? ""
        theText.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                print("Message successfully saved")
            }
            else {
                print("Error, message not saved")
            }
        }
    }
    
    func refreshEverySecond() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        self.tableView.reloadData()
    }
    
    func onTimer(){
        queryParse()
    }
    
    func queryParse() {
        let query = PFQuery(className:"Message")
        
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages")
                // Do something with the found objects
                self.messages = objects
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messages?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages![indexPath.row]
        
        cell.messageText.text = message["text"] as? String
        
        if let user = message["user"] as? PFUser{
            user.fetchInBackground(block: {(user, error) in
                if let user = user as? PFUser{
                    cell.usernameLabel.text = user.username
                }})
            }
        cell.usernameLabel.text = message["user"] as? String
        
        return cell
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
