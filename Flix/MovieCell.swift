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
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
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
            //posterImageView.af_setImage(withURL: posterURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.white
        overviewLabel.textColor = UIColor.white
    }

}
