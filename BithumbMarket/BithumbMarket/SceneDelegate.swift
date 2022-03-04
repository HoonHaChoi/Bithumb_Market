//
//  SceneDelegate.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let screen = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        navigationController.setViewControllers([MainViewController(viewmodel: .init(), datasource: .init())], animated: true)
        navigationController.isNavigationBarHidden = true
//        navigationController.setViewControllers([DetailViewController()], animated: true)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = screen
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

