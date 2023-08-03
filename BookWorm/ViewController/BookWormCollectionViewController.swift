//
//  BookWormCollectionViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class BookWormCollectionViewController: UICollectionViewController {
    
    let searchBar = UISearchBar()
    
    var movieList = MovieInfo(){
        didSet{
            collectionView.reloadData()
        }
    }
    lazy var searchMovieList: [Movie] = movieList.movie {
        didSet{
            collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: BookWormCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BookWormCollectionViewCell")
        self.title = "고래밥님의 책장"
        setCollectionViewLayout()
        setUpSearchBar()
      
    }
    
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        
//        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else { return }
        
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
    
        return searchMovieList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookWormCollectionViewCell.identifier, for: indexPath) as! BookWormCollectionViewCell
        
        let movie = searchMovieList[indexPath.row]
        
        cell.configreCollectionCell(movie: movie)
        
    
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        print("\(sender.tag)")
        searchMovieList[sender.tag].like.toggle()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        
        vc.movie = searchMovieList[indexPath.row]
        
        vc.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

    

}


extension BookWormCollectionViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            resetAllMovie()
            return
        }
        searchMovie(title : text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetAllMovie()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//        print(searchBar.text!)
        if searchText.isEmpty {
            resetAllMovie()
        }else{
            searchMovie(title : searchText)
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        resetAllMovie()
    }
    
    // 해당 영화 찾는 함수
    func searchMovie(title : String){
        searchMovieList.removeAll()
        for item in movieList.movie {
            if item.title.contains(title){
                searchMovieList.append(item)
            }
        }
        collectionView.reloadData()
    }
    // 찾는게 없을때 전부 셋팅 함수
    func resetAllMovie(){
        searchMovieList.removeAll()
        searchBar.text = ""
        for item in movieList.movie {
            searchMovieList.append(item)
        }
        collectionView.reloadData()
    }


    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
//        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
}
