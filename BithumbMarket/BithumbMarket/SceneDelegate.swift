//
//  SceneDelegate.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dependency: AppDependency
    
    private override init() {
        self.dependency = AppDependency()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: dependency.initialMainVC())
        window?.makeKeyAndVisible()
    }

}

