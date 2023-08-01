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
    @IBOutlet weak var likeIamgeView: UIImageView!
    
    
    func configreCollectionCell(movie: Movie){
        
        self.layer.cornerRadius = 20
        backgroundColor = .randomColor()
        
        titleLabel.text = movie.title
        titleLabel.textColor = .white
        posterImageView.image = UIImage(named: movie.title)
        rateLabel.text = "\(movie.rate)"
        rateLabel.textColor = .white
        likeIamgeView.tintColor = .white

        if movie.like {
            likeIamgeView.image = UIImage(systemName: "hand.thumbsup.fill")
        }else{
            likeIamgeView.image = UIImage(systemName: "hand.thumbsup")
        }

    }
}
