//
//  DetailsViewController.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/24/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit

enum MovieKeys {
    static let results = "results"
    static let title = "title"
    static let release = "release_date"
    static let overview = "overview"
    static let backdrop =  "backdrop_path"
    static let poster = "poster_path"
    static let key = "key"
    static let id = "id"
}

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var youtubeURL: URL?
    var movie: [String: Any]?
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            let idNumber = movie["id"] as! NSNumber
            id = "\(idNumber)"
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie[MovieKeys.release] as? String
            overviewLabel.text = movie[MovieKeys.overview] as? String
            let backdropPathString = movie[MovieKeys.backdrop] as! String
            let posterPathString =  movie[MovieKeys.poster] as! String
            let baseURL = "https://image.tmdb.org/t/p/original"
            let baseBackdropURL = "https://image.tmdb.org/t/p/original"
            let backdropURL = URL(string: baseBackdropURL + backdropPathString)!
            backdropImageView.af_setImage(withURL: backdropURL)
            
            let posterURL = URL(string: baseURL + posterPathString)!
            posterImageView.af_setImage(withURL: posterURL, placeholderImage: UIImage(named: "plaeholder"))
            
        }
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.imageTapped(_:)))
        posterImageView.addGestureRecognizer(pictureTap)
        posterImageView.isUserInteractionEnabled = true
        overviewLabel.sizeToFit()
        
        fetchVideoLink()
    }
    
    func fetchVideoLink() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + id + "/videos?api_key=edce9e69356447e62c65bf14906e8ab1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns.
            if let error = error {
                print(error.localizedDescription)
                
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let videos = dataDictionary[MovieKeys.results] as! [[String: Any]]
                let youtubeEndURL = videos[0][MovieKeys.key] as! String
               
                self.youtubeURL = URL(string: "https://www.youtube.com/watch?v=" + youtubeEndURL)
                
            }
        }
        task.resume()
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrailerViewController
        vc.youtubeURL = self.youtubeURL
    }
}
