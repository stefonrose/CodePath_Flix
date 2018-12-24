//
//  PosterCell.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/26/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    var movie: Movie! {
        didSet{
            if movie.posterFound! {
                posterImageView.af_setImage(withURL: movie.posterURL!, placeholderImage: UIImage(named: "poster-placeholder"))
            } else {posterImageView.image = UIImage(named: "poster-placeholder")}
            
        }
    }
}
