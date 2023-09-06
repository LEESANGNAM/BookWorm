//
//  RealmModel.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/04.
//

import Foundation
import RealmSwift

class RealmBook: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var isbn: String
    @Persisted var title: String //책제목
    @Persisted var authors: String // 저자
    @Persisted var releaseDate: String //
    @Persisted var price: Int // 
    @Persisted var overview: String
    @Persisted var urlString: String
    @Persisted var islikeCheck: Bool
    @Persisted var memo:String?
    
    var url: URL{
        return URL(string: urlString) ?? URL(string: "www.naver.com")!
    }
    
    convenience init(isbn:String, title: String, authors: String, releaseDate: String, price: Int, overview: String, urlString: String, islikeCheck: Bool = false, memo: String? = nil) {
        self.init()
        self.isbn = isbn
        self.title = title
        self.authors = authors
        self.releaseDate = releaseDate
        self.price = price
        self.overview = overview
        self.urlString = urlString
        self.islikeCheck = islikeCheck
        self.memo = memo
    }
}
