//
//  CoreDataManager+Extensions.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//

import Foundation
import CoreData

enum PersistentState {
    case add
    case remove
    case update
}

enum errorCase: Error {
    case noData
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    func update(with viewModel: LikedMovieModel?, withAction action: PersistentState, and completion: @escaping (Result<PersistentState, Error>) -> Void) {
        
        switch action {
        case .add:
            guard let viewModel = viewModel else {return}
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedMovie")
            request.predicate = NSPredicate(format: "id == %i", viewModel.id)
            if let likedMovie = try? manObjContext.fetch(request) as? [LikedMovie], likedMovie.isEmpty {
                let liked = LikedMovie(context: manObjContext)
                liked.id = NSNumber(value: viewModel.id).int64Value
                liked.isLiked = viewModel.isLiked
                liked.currentDate = Date()
                do {
                    try manObjContext.save()
                    completion(.success(.add))
                } catch {
                    completion(.failure(error))
                }
            }
        case .remove:
            guard let viewModel = viewModel else {return}
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedMovie")
            request.predicate = NSPredicate(format: "id == %i", viewModel.id)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try manObjContext.execute(deleteRequest)
                completion(.success(.remove))
            } catch {
                completion(.failure(error))
            }
        case .update:
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LikedMovie")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try manObjContext.execute(deleteRequest)
                completion(.success(.remove))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
    }
    
    func requestModels() -> [LikedMovie] {
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(LikedMovie.currentDate), ascending: true)
        request.sortDescriptors = [sort]
        let likedMovies = try? manObjContext.fetch(request)
        guard let likedMovie = likedMovies else { return [LikedMovie]() }
        return likedMovie
    }
    
    func requestModels(withId id: Int) throws -> [LikedMovie] {
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        let likedMovies = try? manObjContext.fetch(request)
        guard let likedMovie = likedMovies else { throw errorCase.noData }
        return likedMovie
    }
    
    
}
