//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/26/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit



class SuperheroViewController: UIViewController, UICollectionViewDataSource {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = (collectionView.frame.size.width / cellsPerLine) - (interItemSpacingTotal / cellsPerLine)
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        fetchMovies()
        
    }
    
    func fetchMovies() {
        MovieAPIClient().superheroMovies { (movies, error) in
            if let movies = movies {
                self.movies = movies
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        cell.movie = movies[indexPath.item]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailsViewController
            detailViewController.movie = movie
        }
    }
}
