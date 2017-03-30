//
//  MoviesViewController.swift
//  MovieViewer
//

import UIKit
import AFNetworking
import MBProgressHUD
import ReachabilitySwift

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkError: UIView!
    
    var page: Int = 1
    var endpoint: String!
    var movies: [NSDictionary] = []
    var filteredMovies: [NSDictionary] = []
    var isMoreDataLoading = false
    var searchBarEmpty = true;
    var loadingMoreView:InfiniteScrollActivityView?
    let darkBrown = UIColor(red: 0.1, green: 0.07, blue: 0.02, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = darkBrown
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
            navigationBar.tintColor = UIColor.orange
        }
        if let tabBar = tabBarController?.tabBar {
            tabBar.barTintColor = darkBrown
            tabBar.tintColor = UIColor.orange
        }
        
        tableView.backgroundColor = darkBrown
        
        searchBar.barTintColor = darkBrown
        searchBar.tintColor = .orange
        searchBar.backgroundColor = darkBrown
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor(red: 0.76, green: 0.47, blue: 0.36, alpha: 1.0)
        searchTextField?.textColor = darkBrown
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Show error message when there is a networking error
        // Credits to Ashley Mills for reachability code template
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.networkError.isHidden = true
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.networkError.isHidden = false
                self.searchBar.isHidden = true
                self.tableView.isHidden = true
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

        self.networkRequest()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.networkRequest()
        refreshControl.endRefreshing()
    }
    
    func loadMoreData() {
        page += 1
        self.networkRequest()
    }
    
    func networkRequest() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)&page=\(page)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
            { (data, response,error) in
                
                // Update flag
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                // Use the new data to update the data source
                let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    if let data = data {
                        if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                              self.movies += (dataDictionary["results"] as? [NSDictionary])!
                              self.tableView.reloadData()
                              MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                }
                task.resume()
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
        });
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Load more results
                loadMoreData()		
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBar.text?.isEmpty)! {
            return movies.count
        }
        else {
            return filteredMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.backgroundColor = darkBrown
        cell.selectionStyle = .none
        
        let movie = movies[indexPath.row]
        
        let lowResBaseUrl = "https://image.tmdb.org/t/p/w45"
        let highResBaseUrl = "https://image.tmdb.org/t/p/w500"
        
        var title: String
        var rating: String
        var releaseDate: String
        var overview: String
        
        if (searchBar.text?.isEmpty)! {
            title = movie["title"] as! String
            
            let voteAverage = Float(String(describing: movie["vote_average"]!))!
            let voteAverageRounded = String(format: "%.1f", arguments: [voteAverage])
            rating = voteAverageRounded
            
            releaseDate = String(describing: movie["release_date"]!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.date(from: releaseDate)
            dateFormatter.dateFormat = "MMMM d, yyyy"
            releaseDate = "Release: " + dateFormatter.string(from: formattedDate!)
            
            overview = movie["overview"] as! String
            
            if let posterPath = movie["poster_path"] as? String {
                cell.titleLabel.text = title
                cell.ratingLabel.text = rating
                cell.releaseDateLabel.text = releaseDate
                cell.overviewTextView.text = overview
                fadeInDetails(lowResBaseUrl + posterPath, highResImageUrl: highResBaseUrl + posterPath, title: title, rating: rating, releaseDate: releaseDate, overview: overview, cellForRowAt: indexPath, cell: cell)
            }
        }
        else {
            let filteredMovie = filteredMovies[indexPath.row]
            title = filteredMovie["title"] as! String
            
            let voteAverage = Float(String(describing: movie["vote_average"]!))!
            let voteAverageRounded = String(format: "%.1f", arguments: [voteAverage])
            rating = voteAverageRounded
            
            releaseDate = String(describing: movie["release_date"]!)
            
            overview = filteredMovie["overview"] as! String
            
            if let posterPath = filteredMovie["poster_path"] as? String {
                fadeInDetails(lowResBaseUrl + posterPath, highResImageUrl: highResBaseUrl + posterPath, title: title, rating: rating, releaseDate: releaseDate, overview: overview, cellForRowAt: indexPath, cell: cell)
            }
        }
        
        cell.overviewTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        return cell
    }
    
    // Fade in title, overview, and image loaded from network
    // Load low resolution image first, then switch to high resolution image
    func fadeInDetails(_ lowResImageUrl: String, highResImageUrl: String, title: String, rating: String, releaseDate: String, overview: String, cellForRowAt indexPath: IndexPath, cell: MovieCell) {
        let lowResImageRequest = NSURLRequest(url: NSURL(string: lowResImageUrl)! as URL)
        let highResImageRequest = NSURLRequest(url: NSURL(string: highResImageUrl)! as URL)

        cell.titleLabel.text = title
        cell.ratingLabel.text = rating + "/10"
        cell.overviewTextView.text = overview
        cell.releaseDateLabel.text = releaseDate
        
        if Double(rating) == 0.0 {
            cell.ratingLabel.layer.backgroundColor = UIColor.gray.cgColor
            cell.ratingLabel.text = "Unrated"
        }
        else if Double(rating)! >= 7.0 {
            cell.ratingLabel.layer.backgroundColor = UIColor.green.cgColor
        }
        else if Double(rating)! >= 6.0 {
            cell.ratingLabel.layer.backgroundColor = UIColor.yellow.cgColor
        }
        else {
            cell.ratingLabel.layer.backgroundColor = UIColor.red.cgColor
        }
        
        cell.ratingLabel.layer.cornerRadius = 3
        
        cell.posterView.setImageWith(lowResImageRequest as URLRequest, placeholderImage: nil, success: { (lowResImageRequest, lowResImageResponse, lowResImage) -> Void in
            
            // ImageResponse will be nil if the image is cached
            if lowResImageResponse != nil {
                // Image not cached, so fade in image
                cell.posterView.alpha = 0.0
                cell.posterView.image = lowResImage
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    cell.posterView.alpha = 1.0
                }, completion: { (success) -> Void in
                    self.setTheImage(cell, request: highResImageRequest, placeholderImage: lowResImage)
                })
            }
            else {
                // Image was cached so update image
                self.setTheImage(cell, request: highResImageRequest, placeholderImage: lowResImage)
            }
        },
        failure: { (imageRequest, imageResponse, error) -> Void in
            self.setTheImage(cell, request: highResImageRequest, placeholderImage: UIImage(named: "ImageNA")!)
        })
    }
    
    func setTheImage(_ cell: MovieCell, request: NSURLRequest, placeholderImage: UIImage) {
        cell.posterView.setImageWith(request as URLRequest, placeholderImage: placeholderImage, success: { (imageRequest, imageResponse, image) -> Void in
            cell.posterView.image = image
        }, failure: { (request, response, error) -> Void in
            cell.posterView.image = placeholderImage
        })
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        networkRequest()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
            searchBarEmpty = true;
        }
        else {
            searchBarEmpty = false;
            filteredMovies = movies.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    return title.range(of: searchText, options: .caseInsensitive) != nil
                }
                return false
            })
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let detailViewController = segue.destination as! DetailViewController
        if (searchBarEmpty) {
            detailViewController.movie = movies[(indexPath?.row)!]
        }
        else {
            detailViewController.movie = filteredMovies[(indexPath?.row)!]
        }
    }
    
}
