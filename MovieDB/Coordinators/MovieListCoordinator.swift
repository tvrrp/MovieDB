//
//  MovieListCoordinator.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import UIKit

final class MovieListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let movieListViewController = MovieListViewController()
        let movieListViewModel = MovieListViewModel()
        movieListViewModel.coordinator = self
        movieListViewController.viewModel = movieListViewModel
        navigationController.setViewControllers([movieListViewController], animated: false)
    }
    
    func startDetailVCPresent(){
        let movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController)
        childCoordinators.append(movieDetailCoordinator)
        movieDetailCoordinator.start()
    }
    
}
