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
    var bookList: Results<RealmBook>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: BookWormCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: BookWormCollectionViewCell.identifier)
        title = "나의 책방"
        bookList = RealmDBManager.shared.readAllRealmBook()
        setCollectionViewLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookList = RealmDBManager.shared.readAllRealmBook()
        collectionView.reloadData()
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        print("button Tapped")
        let book = bookList[sender.tag]
        let islike = book.islikeCheck
        if islike{
            RealmDBManager.shared.updateRealmBook(book: book, newLike: false,newMemo: book.memo)
        } else{
            RealmDBManager.shared.updateRealmBook(book: book, newLike: true,newMemo: book.memo)
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
        
        let book = bookList[indexPath.row]
        cell.configreCollectionCell(book: book)
        cell.backgroundColor = .systemBlue
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = bookList[indexPath.row]
        showActionSheet(text: ""){ actionType in
            switch actionType{
            case .update:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
                vc.book = book
                vc.modalTransitionStyle = .coverVertical
                self.navigationController?.pushViewController(vc, animated: true)
            case .delete:
                ImageFileManager.shared.removeImageFromDocument(fileName: "\(book.isbn).jpg")
                RealmDBManager.shared.deleteRealmBook(book: book)
                self.collectionView.reloadData()
            case .cancle:  self.dismiss(animated: true)
            }
        }
    }
}



