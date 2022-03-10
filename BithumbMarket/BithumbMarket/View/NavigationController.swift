//
//  NavigationController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/10.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        self.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        self.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationItem.compactAppearance = navigationBarAppearance
        self.navigationBar.tintColor = .typoColor
        self.navigationBar.backgroundColor = .systemBackground
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
