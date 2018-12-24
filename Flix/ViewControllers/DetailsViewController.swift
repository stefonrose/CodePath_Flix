//
//  DetailsViewController.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/24/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var topHalf: UIView!
    
    var youtubeURL: URL?
    var movie: Movie?
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.imageTapped(_:)))
        posterImageView.addGestureRecognizer(pictureTap)
        posterImageView.isUserInteractionEnabled = true
        setMovie()
        fetchVideoLink()
    }
    
    func setMovie() {
        if let movie = movie {
            id = "\(movie.id)"
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            if movie.backdropFound! {
                backdropImageView.af_setImage(withURL: movie.backdropURL!, placeholderImage: UIImage(named: "backdrop-placeholder"))
            } else {backdropImageView.image = UIImage(named: "backdrop-placeholder")}
            if movie.posterFound! {
                posterImageView.af_setImage(withURL: movie.posterURL!, placeholderImage: UIImage(named: "poster-placeholder"))
            } else {posterImageView.image = UIImage(named: "poster-placeholder")}
        }
    }
    
    func fetchVideoLink() {
        let databaseURL = URL(string: "https://api.themoviedb.org/3/movie/" + id + "/videos?api_key=edce9e69356447e62c65bf14906e8ab1")!
        MovieAPIClient().youtubeLink(url: databaseURL) { (url, error) in
            if let url = url {
                self.youtubeURL = url
            }
        }
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
