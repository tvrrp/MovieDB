//
//  CoreDataManager+Protocol.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func update(with viewModel: LikedMovieModel?,
                withAction action: PersistentState,
             and completion: @escaping (Result<PersistentState, Error>) -> Void)
    
    func requestModels() -> [LikedMovie]
    func requestModels(withId id: Int) throws -> [LikedMovie]
}
