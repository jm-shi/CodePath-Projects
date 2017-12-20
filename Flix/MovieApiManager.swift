//
//  MovieApiManager.swift
//  Flix
//
//  Created by Jamie Shi on 12/9/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

class MovieApiManager {
    
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func showMovies(listedMovies: [Movie], endpoint: String, page: String, completion: @escaping ([Movie]?, Error?) -> ()) {
        var shownMovies = listedMovies
        let url = URL(string: MovieApiManager.baseUrl + "\(endpoint)?api_key=\(MovieApiManager.apiKey)" + "&page=\(page)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                
                shownMovies += Movie.movies(dictionaries: movieDictionaries)
                completion(shownMovies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
