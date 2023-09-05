//
//  BookWormCollectionViewCell.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit
import Kingfisher

class BookWormCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    
    func configreCollectionCell(book: Book){
        
        self.layer.cornerRadius = 20
        backgroundColor = book.color
        
        titleLabel.text = book.title
        titleLabel.textColor = .white
        posterImageView.kf.setImage(with: book.url)
        rateLabel.text = "\(book.price)원"
        rateLabel.textColor = .white
        likeButton.tintColor = .white
        likeButton.setTitle("", for: .normal)

        if book.like {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }else{
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }

    }
    func configreCollectionCell(book: RealmBook){
        
        self.layer.cornerRadius = 20
        
        titleLabel.text = book.title
        titleLabel.textColor = .white
        posterImageView.kf.setImage(with: book.url)
        rateLabel.text = "\(book.price)원"
        rateLabel.textColor = .white
        likeButton.tintColor = .white
        likeButton.setTitle("", for: .normal)

        if book.islikeCheck {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }else{
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }

    }
}
