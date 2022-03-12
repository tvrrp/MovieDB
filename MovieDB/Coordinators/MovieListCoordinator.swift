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
    private let movieListViewController = MovieListViewController()
    
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let movieListViewModel = MovieListViewModel()
        movieListViewModel.coordinator = self
        movieListViewController.viewModel = movieListViewModel
        navigationController.setViewControllers([movieListViewController], animated: false)
    }
    
    func startDetailVCPresent(with post: Int){
        let movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController, post: post)
        movieDetailCoordinator.parentCoordinator = self
        childCoordinators.append(movieDetailCoordinator)
        movieDetailCoordinator.start()
    }
    
    func startLikedVCPresent(){
        let movieLikedCoordinator = MovieLikedCoordinator(navigationController: navigationController)
        childCoordinators.append(movieLikedCoordinator)
        movieLikedCoordinator.parentCoordinator = self
        movieLikedCoordinator.parentViewController = movieListViewController
        movieLikedCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator){
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
