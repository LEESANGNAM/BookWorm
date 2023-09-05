//
//  BookWormCollectionViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import RealmSwift

class BookWormCollectionViewController: UICollectionViewController {
    
    let searchBar = UISearchBar()
    
    var isSearch = false
    
    var bookList: [RealmBook] = []
//    var booktitleList: [String] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막인지 점검하는 프로퍼티
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: BookWormCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: BookWormCollectionViewCell.identifier)
        self.title = "고래밥님의 책장"
        collectionView.prefetchDataSource = self
        
        APIManager.shard.callRequest(page: page) {
            self.bookList = $0
        }
        setCollectionViewLayout()
        setUpSearchBar()
        
    }
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(identifier: SearchViewController.identifier) as? SearchViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    @objc func likeButtonTapped(_ sender: UIButton){
        print("button Tapped")
        let book = bookList[sender.tag]
        let islike = book.islikeCheck
        // false 일때 true로 바꾸고 테이블에 추가
        if !islike{
            book.islikeCheck.toggle()
            try! realm.write {
                realm.add(book)
                print("Realm Add Succeed")
            }
            collectionView.reloadData()
        }
    }
}

// UICollectionView
extension BookWormCollectionViewController{
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
        return bookList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookWormCollectionViewCell.identifier, for: indexPath) as! BookWormCollectionViewCell
        
        var book = bookList[indexPath.row]
        cell.configreCollectionCell(book: book)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
        vc.book = bookList[indexPath.row]
        vc.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
extension BookWormCollectionViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths{
            if bookList.count - 1 == indexPath.row && page < 15 && !isEnd {
                page += 1
//                callRequest(text: searchBar.text!, page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("취소구현 알아보기 \(indexPaths)")
    }
    
    

}



// UISearchBarDelegate
extension BookWormCollectionViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        bookList.removeAll()
//        booktitleList.removeAll()
        guard let text = searchBar.text, !text.isEmpty else {  return }
        searchBar.resignFirstResponder()
//        callRequest(text: text, page: page)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        isSearch = false
        searchBar.text = ""
        bookList.removeAll()
//        callRequest(page: page)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        page = 1
        bookList.removeAll()
//        callRequest(text: searchText, page: page)

    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
}

