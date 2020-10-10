//
//  SceneDelegate.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 8/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        appCoordinator = AppCoordinator(window: UIWindow(windowScene: windowScene))
        appCoordinator?.start()
    }
}

