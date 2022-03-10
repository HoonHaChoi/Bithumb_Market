//
//  BaseViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/11.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    lazy var showError = { [weak self] (message: String) -> Void in
        self?.showErrorMessage(message)
    }

}
