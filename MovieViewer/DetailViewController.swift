//
//  DetailViewController.swift
//  MovieViewer
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWith(posterUrl! as URL)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
