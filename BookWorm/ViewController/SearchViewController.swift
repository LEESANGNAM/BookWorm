//
//  SearchViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit
import Kingfisher
class SearchViewController: UIViewController {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    let searchBar = UISearchBar()
    var page = 1
    var isEnd = false // 현재 페이지가 마지막인지 점검하는 프로퍼티
    var bookList: [RealmBook] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setCellRegister()
        setUpSearchBar()
        setCollectionViewLayout()
    }
    func setDelegate(){
        searchCollectionView.prefetchDataSource = self
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
    }
    func setCellRegister(){
        let nib = UINib(nibName: BookWormCollectionViewCell.identifier, bundle: nil)
        searchCollectionView.register(nib, forCellWithReuseIdentifier: BookWormCollectionViewCell.identifier)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
        searchCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookWormCollectionViewCell.identifier, for: indexPath) as! BookWormCollectionViewCell
        
        let book = bookList[indexPath.row]
        cell.configreCollectionCell(book: book)
        cell.likeButton.tag = indexPath.row
        cell.posterImageView.kf.setImage(with: book.url)
        cell.backgroundColor = .black
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert(text: "책장에 추가하시겠습니까? ", addButtonText: "추가") {
            let book = self.bookList[indexPath.row]
            RealmDBManager.shared.createRealmBook(book: book)
            if let cell = collectionView.cellForItem(at: indexPath) as? BookWormCollectionViewCell{
                if let image = cell.posterImageView.image{
                    ImageFileManager.shared.saveImageToDocument(fileName: "\(book.isbn).jpg", image: image)
                }
            }
        }
    }

}
//MARK: - UICollectionViewDataSourcePrefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths{
            if bookList.count - 1 == indexPath.row && page < 15 && !isEnd {
//                callRequest(text: searchBar.text!, page: page)
                if let text = searchBar.text{
                    page += 1
                    APIManager.shard.callRequest(text: text, page: page) { data in
                        self.bookList += data
                        self.searchCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("취소구현 알아보기 \(indexPaths)")
    }
}


// UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        bookList.removeAll()
        guard let text = searchBar.text, !text.isEmpty else {  return }
        searchBar.resignFirstResponder()
        APIManager.shard.callRequest(text: text, page: page) { data in
            self.bookList += data
            self.searchCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        searchBar.text = ""
        bookList.removeAll()
        searchCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            page = 1
            bookList.removeAll()
            searchCollectionView.reloadData()
            return
        }
        page = 1
        bookList.removeAll()
        APIManager.shard.callRequest(text: searchText, page: page) { data in
            self.bookList += data
            self.searchCollectionView.reloadData()
        }
    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
}
