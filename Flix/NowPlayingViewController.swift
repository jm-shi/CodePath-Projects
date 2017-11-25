//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Jamie Shi on 11/16/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit
import AlamofireImage
import SVProgressHUD
import Reachability

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [[String: Any]] = []
    var filteredMovies: [[String: Any]] = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor.black
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationBar.tintColor = UIColor.white
        }
        if let tabBar = tabBarController?.tabBar {
            tabBar.barTintColor = UIColor.black
            tabBar.tintColor = UIColor.white
        }
        
        searchBar.barTintColor = UIColor.black
        searchBar.tintColor = UIColor.black
        if let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            searchTextField.textColor = UIColor.white
        }
        tableView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        searchBar.delegate = self
        fetchMovies()
    }
    
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        let alertController = UIAlertController(title: "Network error", message: "Your Internet connection appears to be offline.", preferredStyle: .alert)
        let reachability = Reachability()!
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            SVProgressHUD.dismiss()
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                self.fetchMovies()
            }
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        SVProgressHUD.show()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=fbd72556c509fc83d2efb12b935571d4")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                SVProgressHUD.dismiss()
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        }
        else {
            filteredMovies = movies.filter({ (movie: [String: Any]) -> Bool in
                //let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let title = movie["title"] as? String {
                    return title.range(of: searchText, options: .caseInsensitive) != nil
                }
                return false
            })
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBar.text?.isEmpty)! {
            return movies.count
        }
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        var movie: [String: Any]
        
        if (searchBar.text?.isEmpty)! {
            movie = movies[indexPath.row]
        }
        else {
            movie = filteredMovies[indexPath.row]
        }
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500/"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.deselectRow(at: indexPath, animated: true)
            var movie: [String: Any]
            if (searchBar.text?.isEmpty)! {
                movie = movies[indexPath.row]
            }
            else {
                movie = filteredMovies[indexPath.row]
            }
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
}
