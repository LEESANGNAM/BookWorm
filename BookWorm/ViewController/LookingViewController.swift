//
//  LookingViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/02.
//

import UIKit

class LookingViewController: UIViewController{
    
    var movieList = MovieInfo()

    @IBOutlet weak var lookingCollectionView: UICollectionView!
    
    @IBOutlet weak var lookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        configureCollectionViewLayout()
        // Do any additional setup after loading the view.
    }
    
    func showFullScreenPresent(book: Book){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        
        vc.book = book
    
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

}

extension LookingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LookingCollectionViewCell", for: indexPath) as! LookingCollectionViewCell
        cell.posterImageView.image = UIImage(named: movieList.movie[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieList.movie[indexPath.row]
//        showFullScreenPresent(movie: movie)
    }
    
    
    func configureCollectionViewLayout(){
        lookingCollectionView.dataSource = self
        lookingCollectionView.delegate = self
        
        let nib1 = UINib(nibName: "LookingCollectionViewCell", bundle: nil)
        lookingCollectionView.register(nib1, forCellWithReuseIdentifier: "LookingCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        lookingCollectionView.collectionViewLayout = layout
    }
    
    
    
}


extension LookingViewController: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "요즘 인기 작품"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LookingTableViewCell") as! LookingTableViewCell
        
        let movieInfo = movieList.movie[indexPath.row]
        cell.setUpTableViewCell(movie: movieInfo)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieList.movie[indexPath.row]
//        showFullScreenPresent(movie: movie)
    }
    
    
    func configureTableViewLayout(){
        lookingTableView.dataSource = self
        lookingTableView.delegate = self
        lookingTableView.rowHeight = 150
        
        let nib = UINib(nibName: "LookingTableViewCell", bundle: nil)
        lookingTableView.register(nib, forCellReuseIdentifier: "LookingTableViewCell")
    }
}
