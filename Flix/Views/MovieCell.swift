//
//  MovieCell.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/23/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    var movie: Movie! {
        didSet{
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            if movie.posterFound! {
                posterImageView.af_setImage(withURL: movie.posterURL!, placeholderImage: UIImage(named: "poster-placeholder"))
            } else {
                posterImageView.image = UIImage(named: "poster-placeholder")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
