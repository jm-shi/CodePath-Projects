//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Jamie Shi on 11/18/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    var photoURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: photoURL)
        detailsImageView.af_setImage(withURL: url!)
        detailsImageView.contentMode = .scaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
