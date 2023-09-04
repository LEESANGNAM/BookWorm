//
//  RealmModel.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/04.
//

import Foundation
import RealmSwift

class LikeBook: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String //책제목
    @Persisted var authors: String // 저자
    @Persisted var releaseDate: String //
    @Persisted var price: Int // 
    @Persisted var overview: String
    @Persisted var urlString: String
    @Persisted var like: Bool
    
    var url: URL{
        return URL(string: urlString) ?? URL(string: "www.naver.com")!
    }
    
    convenience init(title: String, authors: String, releaseDate: String, price: Int, overview: String, urlString: String, like: Bool) {
        self.init()
        self.title = title
        self.authors = authors
        self.releaseDate = releaseDate
        self.price = price
        self.overview = overview
        self.urlString = urlString
        self.like = like
    }
    convenience init(book: Book){
        self.init()
        self.title = book.title
        self.authors = book.authors
        self.releaseDate = book.releaseDate
        self.price = book.price
        self.overview = book.overview
        self.urlString = book.urlString
        self.like = book.like
    }
   
}
