//
//  DetailViewController.swift
//  Flix
//
//  Created by Jamie Shi on 11/21/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

enum MovieKeys {
    static let title = "title"
    static let release_date = "release_date"
    static let overview = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
    static let id = "id"
}

class DetailViewController: UIViewController {

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            titleLabel.text = movie.title
            ratingLabel.text = "Rating: " + String(movie.vote_average)
            ratingLabel.layer.cornerRadius = 3
            updateRatingColor(rating: movie.vote_average)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.date(from: movie.release_date)
            dateFormatter.dateFormat = "MMMM d, yyyy"
            releaseDateLabel.text = dateFormatter.string(from: formattedDate!)
            
            voteCountLabel.text = String(movie.vote_count) + " Votes"
            overviewLabel.text = movie.overview
           
            let backdropPathString = movie.backdrop_path
            let posterPathString = movie.poster_path
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backdropImageView.af_setImage(withURL: backdropURL)
            
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterPathURL)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let trailerViewController = segue.destination as! TrailerViewController
        trailerViewController.movieID = (movie?.id)!
    }
    
}
