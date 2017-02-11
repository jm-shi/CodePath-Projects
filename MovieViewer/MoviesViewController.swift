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
    
    var endpoint: String!
    var movies: [NSDictionary] = []
    var filteredMovies: [NSDictionary] = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.zero
        
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
        self.networkRequest()
    }
    
    func networkRequest() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)&offset=\(self.movies.count)")!
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
        
        cell.selectionStyle = .none

        let movie = movies[indexPath.row]
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        var title: String
        var overview: String
        
        if (searchBar.text?.isEmpty)! {
            title = movie["title"] as! String
            overview = movie["overview"] as! String
            if let posterPath = movie["poster_path"] as? String {
                cell.titleLabel.text = title
                cell.overviewLabel.text = overview
                fadeInDetails(baseUrl + posterPath, title: title, overview: overview, cellForRowAt: indexPath, cell: cell)
            }
        }
        else {
            let filteredMovie = filteredMovies[indexPath.row]
            title = filteredMovie["title"] as! String
            overview = filteredMovie["overview"] as! String
            if let posterPath = filteredMovie["poster_path"] as? String {
                fadeInDetails(baseUrl + posterPath, title: title, overview: overview, cellForRowAt: indexPath, cell: cell)
            }
        }
        
        return cell
    }
    
    // Fade in title, overview, and image loaded from network
    func fadeInDetails(_ imageUrl: String, title: String, overview: String, cellForRowAt indexPath: IndexPath, cell: MovieCell) {
        
        
        let imageRequest = NSURLRequest(url: NSURL(string: imageUrl)! as URL)
        
        
   //     let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl)! as URL)
   //     let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl)! as URL)
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                }
                else {
                    cell.posterView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
        if searchText.isEmpty {
            filteredMovies = movies
        }
        else {
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
        detailViewController.movie = movies[(indexPath?.row)!]
    }
    
}
