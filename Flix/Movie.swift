//
//  Movie.swift
//  Flix
//
//  Created by Jamie Shi on 12/9/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

class Movie {
    var title: String
    var overview: String
    var poster_path: String
    var release_date: String
    var backdrop_path: String
    var vote_count: Int
    var vote_average: Float
    var id: Int
    var posterUrl: URL?
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as? String ?? "No overview"
        poster_path = dictionary["poster_path"] as? String ?? "No poster path"
        release_date = dictionary["release_date"] as? String ?? "No release date"
        backdrop_path = dictionary["backdrop_path"] as? String ?? "No backdrop path"
        vote_count = dictionary["vote_count"] as? Int ?? 0
        vote_average = dictionary["vote_average"] as? Float ?? 0
        id = dictionary["id"] as? Int ?? 0
        posterUrl = dictionary["posterUrl"] as? URL
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        return movies
    }
    
}
