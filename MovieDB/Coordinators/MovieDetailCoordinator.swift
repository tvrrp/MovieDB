//
//  MovieDetailCoordinator.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

final class MovieDetailCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    
}
