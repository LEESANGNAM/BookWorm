//
//  BookWormCollectionViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class BookWormCollectionViewController: UICollectionViewController {
    
    let movieList = MovieInfo()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "BookWormCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BookWormCollectionViewCell")
        self.title = "고래밥님의 책장"
        setCollectionViewLayout()
      
    }
    
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = sb.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else { return }
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
        
    }
    
    func setCollectionViewLayout(){
        //cell estimated size non으로 인터페이스 빌더에서 설정 할 것!
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 3)
        let itemSize = width / 2
        
        
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        //컬렉션뷰 inset
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        // 최소 간격
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        
    }
   


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return movieList.movie.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookWormCollectionViewCell", for: indexPath) as! BookWormCollectionViewCell
        cell.backgroundColor = .blue
        
        let movie = movieList.movie[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.titleLabel.textColor = .white
        cell.posterImageView.image = UIImage(named: movie.title)
        cell.rateLabel.text = "\(movie.rate)"
        cell.rateLabel.textColor = .white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        
        vc.movie = movieList.movie[indexPath.row]
        
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

    

}
