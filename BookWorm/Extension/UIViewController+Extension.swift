//
//  UIViewController+Extension.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/06.
//

import UIKit

extension UIViewController{
    func showActionSheet(text: String, addButtonText1: String = "메모하기", addButtonText2: String = "삭제하기", Action: ((AlertActionType) -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: text, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel){_ in
            Action?(AlertActionType.cancle)
        }
        alert.addAction(cancel)
        
        let customAction1 = UIAlertAction(title: addButtonText1, style: .default) { _ in
            Action?(AlertActionType.update)
        }
        alert.addAction(customAction1)
        let customAction2 = UIAlertAction(title: addButtonText2, style: .default) { _ in
            Action?(AlertActionType.delete)
        }
        alert.addAction(customAction2)
        
        present(alert, animated: true)
    }
    func showAlert(text: String, addButtonText: String? = nil, Action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: text, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(cancel)
        
        if let buttonText = addButtonText {
            let customAction = UIAlertAction(title: buttonText, style: .default) { _ in
                Action?()
            }
            alert.addAction(customAction)
        }
        present(alert, animated: true)
    }
}
