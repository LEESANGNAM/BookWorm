//
//  DetailViewController.swift
//  BookWorm
//
//  Created by 이상남 on 2023/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: Movie?
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
        
        memoTextView.text = placeHolder
        memoTextView.textColor = .lightGray
        
        title = ""
        setUpUI(movie: movie!)
        if let _ = presentingViewController{ // presentingViewController 라는게 있어서  test 해보니 push할땐 값이 넘어오지 않는다.
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back))
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(movie: Movie){
        movieTitleLabel.text = movie.title
        movieTitleLabel.textColor = .white
        movieTitleLabel.font = .boldSystemFont(ofSize: 20)
        dateLabel.text = movie.releaseDate
        dateLabel.textColor = .white
        timeLabel.text = "\(movie.runtime)분"
        timeLabel.textColor = .white
        rateLabel.text = "\(movie.rate)점"
        overViewLabel.text = movie.overview
        posterImageView.image = UIImage(named: movie.title)
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
