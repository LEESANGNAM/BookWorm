//
//  BookWormCollectionViewCell.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class BookWormCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookWormCollectionViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    
    func configreCollectionCell(movie: Movie){
        
        self.layer.cornerRadius = 20
        backgroundColor = .randomColor()
        
        titleLabel.text = movie.title
        titleLabel.textColor = .white
        posterImageView.image = UIImage(named: movie.title)
        rateLabel.text = "\(movie.rate)"
        rateLabel.textColor = .white
        likeButton.tintColor = .white
        likeButton.setTitle("", for: .normal)

        if movie.like {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }else{
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }

    }
}
