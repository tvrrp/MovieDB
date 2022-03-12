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
    func childDidFinish(_ childCoordinator: Coordinator)
}

final class AppCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {

    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        navigationController.delegate = self
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController)
        childCoordinators.append(movieListCoordinator)
        movieListCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {}

}
