//
//  DetailViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: Movie?

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "상세화면"
        setUpUI(movie: movie!)
        self.navigationController?.navigationBar.topItem?.title = ""
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(movie: Movie){
        self.title = movie.title
        dateLabel.text = movie.releaseDate
        timeLabel.text = "\(movie.runtime)분"
        rateLabel.text = "\(movie.rate)점"
        overViewLabel.text = movie.overview
        posterImageView.image = UIImage(named: movie.title)
    }
    
    

}
