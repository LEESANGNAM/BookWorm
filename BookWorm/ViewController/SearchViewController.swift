//
//  SearchViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색화면"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(back) )
     
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func back(){
        dismiss(animated: true)
    }

}
