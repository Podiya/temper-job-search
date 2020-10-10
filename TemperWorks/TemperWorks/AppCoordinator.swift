//
//  AppCoordinator.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 8/10/20.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let controller = UINavigationController(rootViewController: JobListViewController(viewModel: JobListViewModel()))
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
