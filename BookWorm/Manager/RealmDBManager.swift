//
//  RealmDBManager.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/05.
//

import Foundation
import RealmSwift

class RealmDBManager {
    static let shared = RealmDBManager()
    
    let realm: Realm
    private init() {
        realm = try! Realm()
        print(realm.configuration.fileURL)
    }
    
    func createRealmBook(book: RealmBook){
        try! realm.write {
            realm.add(book)
        }
    }
    
    func readLikeRealmBook()->Results<RealmBook>{
        let likeBooks = realm.objects(RealmBook.self).filter("islikeCheck == true")
        return likeBooks
    }
    
    func readAllRealmBook() -> Results<RealmBook> {
       return realm.objects(RealmBook.self)
    }
    
    func updateRealmBook(book: RealmBook ,newLike: Bool? = nil,newMemo:String? = nil) {
        try! realm.write {
            if let like = newLike {
                book.islikeCheck = like
            }
            if let memo = newMemo {
                book.memo = memo
            } else {
                book.memo = nil
            }
        }
    }
    
    func deleteRealmBook(book: RealmBook) {
        try! realm.write {
            realm.delete(book)
        }
    }
}
