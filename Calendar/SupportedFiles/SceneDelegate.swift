//
//  SceneDelegate.swift
//  Calendar
//
//  Created by Admin on 22.01.2021.
//

import UIKit



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var router: Router?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let navigationController = UINavigationController()
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        let router = Router(navigationController: navigationController)
        router.startFlow()
        self.router = router
    }
    
}

