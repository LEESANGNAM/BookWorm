//
//  UIViewController+Extension.swift
//  BookWorm
//
//  Created by 이상남 on 2023/09/06.
//

import UIKit

extension UIViewController{
    func showActionSheet(text: String, addButtonText1: String = "수정하기", addButtonText2: String = "삭제하기", Action: ((AlertActionType) -> Void)? = nil) {
        let alert = UIAlertController(title: "짜잔", message: text, preferredStyle: .actionSheet)
        
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
}
