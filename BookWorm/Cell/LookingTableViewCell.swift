//
//  LookingTableViewCell.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/02.
//

import UIKit

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

    
    func setUpTableViewCell(movie: Movie){
        mainTitleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        timeRateLabel.text = "\(movie.runtime)분 평점 : \(movie.rate) 점"
        posterImageView.image = UIImage(named: movie.title)
    }
    
    
}
