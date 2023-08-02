//
//  LookingViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/02.
//

import UIKit

class LookingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    var movieList = MovieInfo()

    @IBOutlet weak var lookingCollectionView: UICollectionView!
    
    @IBOutlet weak var lookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookingTableView.dataSource = self
        lookingTableView.delegate = self
        
        lookingCollectionView.dataSource = self
        lookingCollectionView.delegate = self
        
        let nib = UINib(nibName: "LookingTableViewCell", bundle: nil)
        lookingTableView.register(nib, forCellReuseIdentifier: "LookingTableViewCell")
        lookingTableView.rowHeight = 150
        
        let nib1 = UINib(nibName: "LookingCollectionViewCell", bundle: nil)
        lookingCollectionView.register(nib1, forCellWithReuseIdentifier: "LookingCollectionViewCell")
        configureCollectionViewLayout()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LookingCollectionViewCell", for: indexPath) as! LookingCollectionViewCell
        cell.posterImageView.image = UIImage(named: movieList.movie[indexPath.row].title)
        return cell
    }
    
    func configureCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        lookingCollectionView.collectionViewLayout = layout
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "요즘 인기 작품"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LookingTableViewCell") as! LookingTableViewCell
        
        let movieInfo = movieList.movie[indexPath.row]
        
        cell.mainTitleLabel.text = movieInfo.title
        cell.dateLabel.text = movieInfo.releaseDate
        cell.timeRateLabel.text = "\(movieInfo.runtime)분 평점 : \(movieInfo.rate) 점"
        cell.posterImageView.image = UIImage(named: movieInfo.title)
        return cell
    }
    

}
