//
//  UIViewController+Extension.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/06.
//

import UIKit

extension UIViewController{
    func showActionSheet(text: String, addButtonText1: String? = nil, addButtonText2: String? = nil, Action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "짜잔", message: text, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        
        if let buttonText = addButtonText1 {
            let customAction1 = UIAlertAction(title: buttonText, style: .default) { _ in
                Action?()
            }
            alert.addAction(customAction1)
        }
        if let buttonText = addButtonText2 {
            let customAction2 = UIAlertAction(title: buttonText, style: .default) { _ in
                Action?()
            }
            alert.addAction(customAction2)
        }
        
        present(alert, animated: true)
    }
}
