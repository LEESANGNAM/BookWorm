//
//  LookingViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/02.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class LookingViewController: UIViewController{
    
    var bookCollectionList:[RealmBook] = []
    var bookTableList:[RealmBook] = []
    
    var tablePage = 1
    var collectionPage = 1
    
    var isEnd = false
    
    @IBOutlet weak var lookingCollectionView: UICollectionView!
    
    @IBOutlet weak var lookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        configureCollectionViewLayout()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.shard.callRequest(text: "클린코드", page: collectionPage) { data in
            self.bookCollectionList += data
            self.lookingCollectionView.reloadData()
        }
        APIManager.shard.callRequest(text: "ios", page: tablePage) { data in
            self.bookTableList += data
            self.lookingTableView.reloadData()
        }
        
    }
    
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(identifier: SearchViewController.identifier) as? SearchViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func showFullScreenPresent(book: RealmBook){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        
        vc.book = book
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}

extension LookingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookCollectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LookingCollectionViewCell", for: indexPath) as! LookingCollectionViewCell
        cell.posterImageView.kf.setImage(with: bookCollectionList[indexPath.row].url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = bookCollectionList[indexPath.row]
        showAlert(text: "책장에 추가하시겠습니까? ", addButtonText: "추가") {
            RealmDBManager.shared.createRealmBook(book: book)
            if let cell = collectionView.cellForItem(at: indexPath) as? BookWormCollectionViewCell{
                if let image = cell.posterImageView.image{
                    ImageFileManager.shared.saveImageToDocument(fileName: "\(book.isbn).jpg", image: image)
                }
            }
        }
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
        return bookTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LookingTableViewCell") as! LookingTableViewCell
        
        let book = bookTableList[indexPath.row]
        cell.setUpTableViewCell(book: book)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = bookTableList[indexPath.row]
        showAlert(text: "책장에 추가하시겠습니까? ", addButtonText: "추가") {
            RealmDBManager.shared.createRealmBook(book: book)
            if let cell = tableView.cellForRow(at: indexPath) as? LookingTableViewCell{
                if let image = cell.posterImageView.image{
                    ImageFileManager.shared.saveImageToDocument(fileName: "\(book.isbn).jpg", image: image)
                }
            }
        }
        
    }
    
    
    func configureTableViewLayout(){
        lookingTableView.dataSource = self
        lookingTableView.delegate = self
        lookingTableView.rowHeight = 150
        
        let nib = UINib(nibName: "LookingTableViewCell", bundle: nil)
        lookingTableView.register(nib, forCellReuseIdentifier: "LookingTableViewCell")
    }
}

//MARK: - PreFetching, JSON
extension LookingViewController: UITableViewDataSourcePrefetching, UICollectionViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if bookTableList.count - 1 == indexPath.row && tablePage < 15 && !isEnd {
                tablePage += 1
                APIManager.shard.callRequest(text: "ios", page: tablePage) { data in
                    self.bookTableList += data
                    self.lookingTableView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if bookCollectionList.count - 1 == indexPath.row && collectionPage < 15 && !isEnd {
                collectionPage += 1
                APIManager.shard.callRequest(text: "클린코드", page: collectionPage) { data in
                    self.bookCollectionList += data
                    self.lookingCollectionView.reloadData()
                }
            }
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



