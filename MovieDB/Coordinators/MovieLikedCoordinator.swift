//
//  MovieLikedCoordinator.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//

import UIKit

final class MovieLikedCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    var parentCoordinator: MovieListCoordinator?
    private let navigationController: UINavigationController
    private let coreDataManager = CoreDataManager()
    
    var parentViewController: UIViewController?
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let movieLikedViewContorller = MovieLikedViewContoroller()
        let movieLikedViewModel = MovieLikedViewModel(coreDataManager: coreDataManager)
        movieLikedViewModel.coordinator = self
        movieLikedViewContorller.viewModel = movieLikedViewModel
        parentViewController?.addChild(movieLikedViewContorller)
        parentViewController?.view.addSubview(movieLikedViewContorller.view)
        movieLikedViewContorller.didMove(toParent: parentViewController)
    }
    
    func startDetailVCPresent(with post: Int){
        let movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController, post: post)
        movieDetailCoordinator.parentCoordinator = self
        childCoordinators.append(movieDetailCoordinator)
        movieDetailCoordinator.start()
    }
    
    func didFinishMovieLiked(_ movieLikedViewController: MovieLikedViewContoroller){
        movieLikedViewController.willMove(toParent: nil)
        movieLikedViewController.view.removeFromSuperview()
        movieLikedViewController.removeFromParent()
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator){
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
