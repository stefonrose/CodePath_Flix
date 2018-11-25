//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/23/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String: Any]] = []
    
    var refreshControl: UIRefreshControl!
    
    let alertController = UIAlertController(title: "Cannot Load Movies", message: "Your device is not connected to the internet.", preferredStyle: .alert)
    
    var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.rowHeight = 210
        activityIndicator.startAnimating()
        fetchMovies()
        
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchMovies()
        }
        alertController.addAction(tryAgainAction)
        
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    
    
    func fetchMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=edce9e69356447e62c65bf14906e8ab1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns.
            if let error = error {
                print(error.localizedDescription)
                self.present(self.alertController, animated: true)
                
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        
//        cell.selectionStyle = .none
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = _ColorLiteralType(red: 0.9304299355, green: 0.3645707369, blue: 0.3275436163, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.af_setImage(withURL: posterURL, placeholderImage: UIImage(named: "plaeholder"))
        
        return cell
    }
    
}

