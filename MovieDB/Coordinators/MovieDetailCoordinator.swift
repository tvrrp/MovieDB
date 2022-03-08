//
//  MovieDetailCoordinator.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

final class MovieDetailCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    let post: Int
    
    init(navigationController: UINavigationController, post: Int){
        self.navigationController = navigationController
        self.post = post
    }
    
    func start() {
        let movieDetailViewContorller = MovieDetailViewController()
        let movieDetailViewModel = MovieDetailViewModel(post: post)
        movieDetailViewModel.coordinator = self
        movieDetailViewContorller.viewModel = movieDetailViewModel
        navigationController.pushViewController(movieDetailViewContorller, animated: true)
    }
    
}
