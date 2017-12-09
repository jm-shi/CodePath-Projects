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

class SuperheroViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieTypeBarButtonItem: UIBarButtonItem!
    
    var movies: [Movie] = []
    
    var refreshControl: UIRefreshControl!
    var showNowPlayingMovies = true
    
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
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SuperheroViewController.didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        collectionView.dataSource = self
        
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
        if (showNowPlayingMovies) {
            movieTypeBarButtonItem.title = "Popular"
        }
        else {
            movieTypeBarButtonItem.title = "Now Playing"
        }
        showNowPlayingMovies = !showNowPlayingMovies
        
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
        
        if (showNowPlayingMovies) {
            MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
                if let movies = movies {
                    self.movies = movies
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                }
            }
        }
        else {
            MovieApiManager().popularMovies { (movies: [Movie]?, error: Error?) in
                if let movies = movies {
                    self.movies = movies
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        let baseURLString = "https://image.tmdb.org/t/p/w500/"
        let posterURL = URL(string: baseURLString + movie.poster_path)
        cell.posterImageView.af_setImage(withURL: posterURL!)

        return cell
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.item]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
     }
    
}
