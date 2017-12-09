//
//  MovieCell.swift
//  Flix
//
//  Created by Jamie Shi on 11/16/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    

    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            
            let posterPathString = movie.poster_path
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            let posterURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.white
        overviewLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
