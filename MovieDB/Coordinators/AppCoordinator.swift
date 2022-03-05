//
//  AppCoordinator.swift
//  MovieDB
//
//  Created by Damir Yackupov on 01.03.2022.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }

    func start()
}

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController)
        childCoordinators.append(movieListCoordinator)
        movieListCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    

}
