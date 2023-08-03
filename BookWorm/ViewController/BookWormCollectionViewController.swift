//
//  BookWormCollectionViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class BookWormCollectionViewController: UICollectionViewController {
    
    let searchBar = UISearchBar()
    
    var isSearch = false
    
    var movieList = MovieInfo(){
        didSet{
            collectionView.reloadData()
        }
    }
    var searchMovieList: [Movie] = []{
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
    
        return isSearch ? searchMovieList.count : movieList.movie.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookWormCollectionViewCell.identifier, for: indexPath) as! BookWormCollectionViewCell
        let movie: Movie
        if isSearch{
            movie = searchMovieList[indexPath.row]
        }else{
            movie = movieList.movie[indexPath.row]
        }
        cell.configreCollectionCell(movie: movie)
        
    
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        // 검색 상태 == true
        if isSearch{
            // 검색된(검색배열에 담긴)타이틀을 비교를 위해 담아놓는다.
            let searchTitle = searchMovieList[sender.tag].title
            // firstindex 클로저로 실행된다. 배열에서 일치하는 title의 인덱스를 가져온다.
            if let index = movieList.movie.firstIndex(where: { Movie in
                Movie.title == searchTitle
            }){ // 버튼의 상태를 바꾼다.
                searchMovieList[sender.tag].like.toggle()
                movieList.movie[index].like.toggle()
            }
        }else{
            // 검색상태가 아니라면 원래 있는 배열의 상태를 변경한다.
            movieList.movie[sender.tag].like.toggle()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        if isSearch{
            vc.movie = searchMovieList[indexPath.row]
        }else{
            vc.movie = movieList.movie[indexPath.row]
        }
        vc.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

    

}


extension BookWormCollectionViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            isSearch = false
            return
        }
        isSearch = true
        searchMovie(title : text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearch = false
            collectionView.reloadData()
        }else{
            isSearch = true
            searchMovie(title : searchText)
        }
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

    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
}
