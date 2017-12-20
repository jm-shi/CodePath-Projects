//
//  TrailerViewController.swift
//  Flix
//
//  Created by Jamie Shi on 11/24/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var trailerWebView: UIWebView!
    
    var movieID: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("test:", movieID)
        trailerWebView.mediaPlaybackRequiresUserAction = false
        trailerWebView.allowsInlineMediaPlayback = true
    
        let movieString = "https://api.themoviedb.org/3/movie/" + String(movieID) + "/videos?api_key=fbd72556c509fc83d2efb12b935571d4&language=en-US"
        let url = URL(string: movieString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let results = dataDictionary["results"] as! [[String: Any]]
                if let movieKey = results[0]["key"] as? String {
                    let movieURL = "https://www.youtube.com/watch?v=" + movieKey
                    print("movieURL: ", movieURL)
                    let movieRequestURL = NSURL(string: movieURL)
                    let movieRequest = NSURLRequest(url: movieRequestURL! as URL)
                    self.trailerWebView.loadRequest(movieRequest as URLRequest)
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissTrailer(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
