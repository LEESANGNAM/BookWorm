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
    
    var bookCollectionList:[Book] = []
    var bookTableList:[Book] = []
    
    var tablePage = 1
    var collectionPage = 1
    
    var isEnd = false

    @IBOutlet weak var lookingCollectionView: UICollectionView!
    
    @IBOutlet weak var lookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpJsonWithPreFetching()
        configureTableViewLayout()
        configureCollectionViewLayout()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        return bookCollectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LookingCollectionViewCell", for: indexPath) as! LookingCollectionViewCell
        cell.posterImageView.kf.setImage(with: bookCollectionList[indexPath.row].url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = bookCollectionList[indexPath.row]
        showFullScreenPresent(book: book)
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
        showFullScreenPresent(book: book)
        
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
                callRequest(text: "ios",page: tablePage,target: lookingTableView)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if bookCollectionList.count - 1 == indexPath.row && collectionPage < 15 && !isEnd {
                collectionPage += 1
                callRequest(text: "python",page: collectionPage,target: lookingCollectionView)
            }
        }
    }
    
    func setUpJsonWithPreFetching(){
        lookingTableView.prefetchDataSource = self
        lookingCollectionView.prefetchDataSource = self
        
        callRequest(text: "python",page: collectionPage,target: lookingCollectionView)
        callRequest(text: "ios",page: tablePage,target: lookingTableView)
    }
    
    
    func callRequest(text: String = "클린코드",page: Int = 1, target: Any){
        
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
                        if let target = target as? UICollectionView{
                            self.bookCollectionList.append(book)
                        }else{
                            self.bookTableList.append(book)
                        }
                        
                    }
                    self.lookingCollectionView.reloadData()
                    self.lookingTableView.reloadData()
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


