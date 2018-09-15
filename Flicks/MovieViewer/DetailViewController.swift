//
//  DetailViewController.swift
//  MovieViewer
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let releaseDate = String(describing: movie["release_date"]!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.date(from: releaseDate)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        releaseDateLabel.text = "Release: " + dateFormatter.string(from: formattedDate!)
        
        let voteAverage = Float(String(describing: movie["vote_average"]!))!
        let rating = String(format: "%.1f", arguments: [voteAverage])
        ratingLabel.text = rating + "/10"
        if Double(rating) == 0.0 {
            ratingLabel.layer.backgroundColor = UIColor.gray.cgColor
            ratingLabel.text = "Unrated"
        }
        else if Double(rating)! >= 7.0 {
            ratingLabel.layer.backgroundColor = UIColor.green.cgColor
        }
        else if Double(rating)! >= 6.0 {
            ratingLabel.layer.backgroundColor = UIColor.yellow.cgColor
        }
        else {
            ratingLabel.layer.backgroundColor = UIColor.red.cgColor
        }
        
        let voteCount = Int(String(describing: movie["vote_count"]!))!
        voteCountLabel.text = String(voteCount) + " votes"
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        
        overviewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWith(posterUrl! as URL)
        }
        
        titleLabel.textColor = UIColor.white
        ratingLabel.textColor = UIColor.black
        overviewLabel.textColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
