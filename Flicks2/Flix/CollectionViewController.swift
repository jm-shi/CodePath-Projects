//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Jamie Shi on 11/21/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit
import AlamofireImage
import SVProgressHUD
import Reachability

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieTypeBarButtonItem: UIBarButtonItem!
    
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    var refreshControl: UIRefreshControl!
    var currMovieType: String = "popular"
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
        
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.barTintColor = UIColor.black
        if let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            searchTextField.textColor = UIColor.white
        }

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CollectionViewController.didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        fetchMovies()
    }

    @IBAction func onMovieType(_ sender: Any) {
        self.movies = []
        self.filteredMovies = []
        if let currMovieType = movieTypeBarButtonItem.title {
            if currMovieType == "Now Playing" {
                movieTypeBarButtonItem.title = "Popular"
                self.currMovieType = "popular"
                self.tabBarController?.tabBar.items?[1].title = "Popular"
            }
            else if currMovieType == "Popular" {
                movieTypeBarButtonItem.title = "Top Rated"
                self.currMovieType = "top_rated"
                self.tabBarController?.tabBar.items?[1].title = "Top Rated"
            }
            else if currMovieType == "Top Rated" {
                movieTypeBarButtonItem.title = "Upcoming"
                self.currMovieType = "upcoming"
                self.tabBarController?.tabBar.items?[1].title = "Upcoming"
            }
            else {
                movieTypeBarButtonItem.title = "Now Playing"
                self.currMovieType = "now_playing"
                self.tabBarController?.tabBar.items?[1].title = "Now Playing"
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
                self.collectionView.reloadData()
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
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        collectionView.reloadData()
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                isMoreDataLoading = true
                page += 1
                fetchMovies()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (searchBar.text?.isEmpty)! {
            return movies.count
        }
        return filteredMovies.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        var movie: Movie
        if (searchBar.text?.isEmpty)! {
            movie = movies[indexPath.item]
        }
        else {
            movie = filteredMovies[indexPath.item]
        }
        
        let baseURLString = "https://image.tmdb.org/t/p/w500/"
        let posterURL = URL(string: baseURLString + movie.poster_path)
        cell.posterImageView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
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
