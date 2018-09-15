//
//  MovieCell.swift
//  Flix
//
//  Created by Jamie Shi on 11/16/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            ratingLabel.text = "Rating: " + String(movie.vote_average)
            updateRatingColor(rating: movie.vote_average)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.date(from: movie.release_date)
            dateFormatter.dateFormat = "MMMM d, yyyy"
            releaseDateLabel.text = dateFormatter.string(from: formattedDate!)
            
            overviewLabel.text = movie.overview
            
            let posterPathString = movie.poster_path
            let lowResBaseURL = "https://image.tmdb.org/t/p/w45/"
            let highResBaseURL = "https://image.tmdb.org/t/p/w500/"
            
            let placeholderImage = UIImage(named: lowResBaseURL + posterPathString)
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: posterImageView.frame.size, radius: 20)
            
            posterImageView.af_setImage(
                withURL: URL(string: highResBaseURL + posterPathString)!,
                placeholderImage: placeholderImage,
                filter: filter,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.white
        releaseDateLabel.textColor = UIColor.white
        ratingLabel.layer.cornerRadius = 3
        overviewLabel.textColor = UIColor.white
    }
    
    func updateRatingColor(rating: Float) {
        if rating == 0.0 {
            ratingLabel.layer.backgroundColor = UIColor.gray.cgColor
            ratingLabel.text = "Unrated"
        }
        else if rating >= 7.0 {
            ratingLabel.layer.backgroundColor = UIColor.green.cgColor
        }
        else if rating >= 6.0 {
            ratingLabel.layer.backgroundColor = UIColor.yellow.cgColor
        }
        else {
            ratingLabel.layer.backgroundColor = UIColor.red.cgColor
        }
    }

}
