//
//  DetailViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit
import Kingfisher
import RealmSwift

class DetailViewController: UIViewController {
    
    var book: RealmBook!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    let placeHolder = "여기에 메모를 해주세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextView.delegate = self
        
        
        
        title = ""
        setUpUI(book: book)
        if let _ = presentingViewController{ // presentingViewController 라는게 있어서  test 해보니 push할땐 값이 넘어오지 않는다.
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back))
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정완료", style: .plain, target: self, action: #selector(updateMemo))
        // Do any additional setup after loading the view.
    }
    @objc func updateMemo(){
        if memoTextView.text.isEmpty{
            RealmDBManager.shared.updateRealmBook(book: book)
        } else if memoTextView.text != placeHolder  {
            RealmDBManager.shared.updateRealmBook(book: book,newMemo: memoTextView.text)
        }
        navigationController?.popViewController(animated: true)
    }
    func setUpUI(book: RealmBook){
        if let memoText = book.memo, !memoText.isEmpty {
            memoTextView.text = memoText
            memoTextView.textColor = .black
        } else{
            memoTextView.text = placeHolder
            memoTextView.textColor = .lightGray
        }
        movieTitleLabel.text = book.title
        movieTitleLabel.textColor = .white
        movieTitleLabel.font = .boldSystemFont(ofSize: 20)
        dateLabel.text = book.releaseDate
        dateLabel.textColor = .white
        timeLabel.text = book.authors
        timeLabel.textColor = .white
        rateLabel.text = "\(book.price)원"
        overViewLabel.text = book.overview
        posterImageView.kf.setImage(with: book.url)
    }
    
    @objc func back(){
          dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
      }
    

}


extension DetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(#function)
        print(textView.text.count)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(#function)
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
        
    }
    
    
}
