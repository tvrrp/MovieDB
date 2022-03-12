//
//  MovieDetailCoordinator.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

final class MovieDetailCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    private let coreDataManager = CoreDataManager()
    
    let post: Int
    
    init(navigationController: UINavigationController, post: Int){
        self.navigationController = navigationController
        self.post = post
    }
    
    func start() {
        let movieDetailViewContorller = MovieDetailViewController()
        let movieDetailViewModel = MovieDetailViewModel(post: post, coreDataManager: coreDataManager)
        movieDetailViewModel.coordinator = self
        movieDetailViewContorller.viewModel = movieDetailViewModel
        navigationController.pushViewController(movieDetailViewContorller, animated: true)
    }
    
    func didFinishMovieDetail(){
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
    }
    
    
}
