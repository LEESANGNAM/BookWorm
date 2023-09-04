//
//  LookingTableViewCell.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/02.
//

import UIKit
import Kingfisher

class LookingTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeRateLabel: UILabel!
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTitleLabel.font = .boldSystemFont(ofSize: 17)
        mainTitleLabel.textColor = .black
    }

    
    func setUpTableViewCell(book: Book){
        mainTitleLabel.text = book.title
        dateLabel.text = book.authors
        timeRateLabel.text = "\(book.price)원"
        posterImageView.kf.setImage(with: book.url)
    }
    
    
}
