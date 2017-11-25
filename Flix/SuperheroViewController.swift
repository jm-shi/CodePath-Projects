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
    
    var movies: [[String: Any]] = []
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
                SVProgressHUD.dismiss()
            }
        }
        task.resume()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
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
