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
    
    var bookList: [Book] = []
//    var booktitleList: [String] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: BookWormCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BookWormCollectionViewCell")
        self.title = "고래밥님의 책장"
        collectionView.prefetchDataSource = self
        
        callRequest(page: page)
        setCollectionViewLayout()
        setUpSearchBar()
        
    }
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    @objc func likeButtonTapped(_ sender: UIButton){
        print("button Tapped")
        bookList[sender.tag].like.toggle()
        let book = bookList[sender.tag]
        let likeBook = LikeBook(book: book)
        print(likeBook)
        let realm = try! Realm()
        try! realm.write {
            realm.add(likeBook)
            print("Realm Add Succeed")
        }
        collectionView.reloadData()
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
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
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
                callRequest(text: searchBar.text!, page: page)
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
        callRequest(text: text, page: page)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        isSearch = false
        searchBar.text = ""
        bookList.removeAll()
        callRequest(page: page)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        page = 1
        bookList.removeAll()
        callRequest(text: searchText, page: page)

    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
}

// MARK: - json
extension BookWormCollectionViewController {
    
    func callRequest(text: String = "클린코드",page: Int){
        
        let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v3/search/book?query=\(text)&size=30&page=\(page)"
        let header: HTTPHeaders = ["Authorization":APIKey.KakaoKey]
        AF.request(url, method: .get,headers: header).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if response.response?.statusCode == 200 {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    for item in json["documents"].arrayValue{
                        let title = item["title"].stringValue
                        let authors = item["authors"][0].stringValue
                        let overview = item["contents"].stringValue
                        let url = item["thumbnail"].stringValue
                        let price = item["price"].intValue
                        let date = item["datetime"].stringValue
                        
                        guard let date = self.dateFormatString(dateString: date, beforeFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", afterFormat: "yyyy-MM-dd") else { return }
                        
                        let book = Book(title: title, authors: authors as! String, releaseDate: date, price: price, overview: overview, urlString: url, like: false, color: .randomColor())
//                        self.booktitleList.append(title)
                        self.bookList.append(book)
                    }
//                    print(self.booktitleList.count)
                    self.collectionView.reloadData()
                }else{
                    print("오류")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func dateFormatString(dateString: String, beforeFormat: String, afterFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = beforeFormat
        if let date = dateFormatter.date(from: dateString){
            dateFormatter.dateFormat = afterFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
