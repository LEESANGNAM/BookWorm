//
//  APIManager.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/05.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager {
    static let shard = APIManager()
    
    private init(){ }
    
    func callRequest(text: String = "클린코드",page: Int,completionHandler: @escaping ([RealmBook])->Void){
        let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v3/search/book?query=\(text)&size=30&page=\(page)"
        let header: HTTPHeaders = ["Authorization":APIKey.KakaoKey]
        AF.request(url, method: .get,headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if response.response?.statusCode == 200 {
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    var bookList: [RealmBook] = []
                    for item in json["documents"].arrayValue{
                        let title = item["title"].stringValue
                        let isbn = item["isbn"].stringValue
                        let authors = item["authors"][0].stringValue
                        let overview = item["contents"].stringValue
                        let url = item["thumbnail"].stringValue
                        let price = item["price"].intValue
                        let date = item["datetime"].stringValue
                        
                        let book = RealmBook(isbn: isbn, title: title, authors: authors , releaseDate: date.changeFormatDateString(), price: price, overview: overview, urlString: url)
                        bookList.append(book)
                    }
                    completionHandler(bookList)
                }else{
                    print("오류")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
