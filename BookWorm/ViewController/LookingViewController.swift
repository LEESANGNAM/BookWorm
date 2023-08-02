//
//  LookingViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/02.
//

import UIKit

class LookingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    

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
        configureCollectionViewLayout()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCollectionCell", for: indexPath)
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LookingTableViewCell") as! LookingTableViewCell
        cell.mainTitleLabel.text = "테스트 제목제목"
        cell.dateLabel.text = "1234-56-78"
        cell.timeRateLabel.text = "123분 평점 0.00분"
        cell.backgroundColor = .brown
        cell.posterImageView.backgroundColor = .blue
        return cell
    }
    

}
