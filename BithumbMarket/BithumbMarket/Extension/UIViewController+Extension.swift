//
//  UIViewController+Extension.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/11.
//

import UIKit

extension UIViewController {
    
    func showErrorMessage(_ error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
