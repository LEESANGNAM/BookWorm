//
//  LikeBookCollectionViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/04.
//

import UIKit
import RealmSwift

class LikeBookCollectionViewController: UICollectionViewController {
    var likeBooksData: Results<RealmBook>!
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegister()
        setCollectionViewLayout()
        // Access all dogs in the realm
        likeBooksData = RealmDBManager.shared.readLikeRealmBook()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
    }
   func setRegister(){
        let nib = UINib(nibName: BookWormCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BookWormCollectionViewCell")
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        print("button Tapped")
        let book = likeBooksData[sender.tag]
        let islike = book.islikeCheck
        if islike{
            RealmDBManager.shared.updateRealmBook(book: book, newLike: false)
        } else{
            RealmDBManager.shared.updateRealmBook(book: book, newLike: true)
        }
        collectionView.reloadData()
    }
}

extension LikeBookCollectionViewController{
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
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return likeBooksData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookWormCollectionViewCell", for: indexPath) as? BookWormCollectionViewCell else { return UICollectionViewCell()}
        let likeBook = likeBooksData[indexPath.item]
        
        cell.configreCollectionCell(book: likeBook)
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        cell.backgroundColor = .blue
        
        // Configure the cell
        return cell
    }
}
