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

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let searchController = UISearchController(searchResultsController: nil)
    //var searchController: MovieSearchController!
    
    var movies: [Movie] = []
    var filteredMovies: [Movie]?
    var totalItems = 0
    
    var refreshControl: UIRefreshControl!
    
    let alertController = UIAlertController(title: "Cannot Load Movies", message: "Your device is not connected to the internet.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //table view setup
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 210
        
        //refresh control setup
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        //get now playing movies from API
        fetchMovies()
        
        //alert controller configuration
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in self.fetchMovies() }
        alertController.addAction(tryAgainAction)
        
        //search controller configuration
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.7125566602, green: 0.2699042559, blue: 0.2571614683, alpha: 1)
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController.searchBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    
//    func configureMovieSearchController() {
//            searchController = MovieSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor.black)
//
//        searchController.movieSearchBar.placeholder = "Search in this awesome bar..."
//        tableView.tableHeaderView = searchController.movieSearchBar
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredMovies = movies.filter { movie in
                return movie.title.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredMovies = movies
        }
        tableView.reloadData()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    
    func fetchMovies() {
        self.activityIndicator.startAnimating()
        MovieAPIClient().nowPlayingMovies { (movies, error) in
            if let movies = movies {
                self.movies = movies
                self.filteredMovies = self.movies
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        totalItems = UserDefaults.standard.object(forKey: "totalItems") as? NSInteger ?? 0
    }
    
    func LoadMoreMovies() {
        MovieAPIClient().nowPlayingMovies { (movies, error) in
            if let movies = movies {
                for movie in movies {
                    self.movies.append(movie)
                    self.filteredMovies!.append(movie)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allMovies = filteredMovies else {
            return 0
        }
        return allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let allMovies = filteredMovies {
            print(indexPath.section)
            cell.movie = allMovies[indexPath.row]
            if indexPath.row == allMovies.count - 1 {
                if totalItems > allMovies.count && (searchController.searchBar.text?.isEmpty)! {
                    pageNum += 1
                    LoadMoreMovies()
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = filteredMovies![indexPath.row]
            let detailViewController = segue.destination as! DetailsViewController
            detailViewController.movie = movie
        }
    }
}

