//
//  Book.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/09.
//

import UIKit

struct Book{
    var title: String
    var authors: String
    var releaseDate: String
    var price: Int
    var overview: String
    var urlString: String
    var like: Bool
    var color: UIColor
    
    var url: URL{
        return URL(string: urlString)!
    }
}


