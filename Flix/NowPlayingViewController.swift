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

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTypeBarButtonItem: UIBarButtonItem!
    
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    var refreshControl: UIRefreshControl!
    var currMovieType: String = "now_playing"
    var page: Int = 1
    var isMoreDataLoading = false
    
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
        searchBar.tintColor = UIColor.white
        if let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            searchTextField.textColor = UIColor.white
        }
        tableView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        fetchMovies()
    }
    
    @IBAction func onMovieType(_ sender: Any) {
        if let currMovieType = movieTypeBarButtonItem.title {
            if currMovieType == "Now Playing" {
                movieTypeBarButtonItem.title = "Popular"
                self.currMovieType = "popular"
                self.tabBarController?.tabBar.items?[0].title = "Popular"
            }
            else if currMovieType == "Popular" {
                movieTypeBarButtonItem.title = "Top Rated"
                self.currMovieType = "top_rated"
                self.tabBarController?.tabBar.items?[0].title = "Top Rated"
            }
            else if currMovieType == "Top Rated" {
                movieTypeBarButtonItem.title = "Upcoming"
                self.currMovieType = "upcoming"
                self.tabBarController?.tabBar.items?[0].title = "Upcoming"
            }
            else {
                movieTypeBarButtonItem.title = "Now Playing"
                self.currMovieType = "now_playing"
                self.tabBarController?.tabBar.items?[0].title = "Now Playing"
            }
        }
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
        
        MovieApiManager().showMovies(listedMovies: movies, endpoint: currMovieType, page: String(page), completion: { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.isMoreDataLoading = false
                SVProgressHUD.dismiss()
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        }
        else {
            filteredMovies = movies.filter({ (movie: Movie) -> Bool in
                return movie.title.range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                page += 1
                fetchMovies()
            }
        }
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
        cell.selectionStyle = .none
        
        if (searchBar.text?.isEmpty)! {
            cell.movie = movies[indexPath.row]
        }
        else {
            cell.movie = filteredMovies[indexPath.row]
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.deselectRow(at: indexPath, animated: true)
            var movie: Movie
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
