//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import CoreData
import UIKit
import Nuke

final class MovieDetailViewModel {

    var coordinator: MovieDetailCoordinator?
    var post: Int
    weak var movieDetailView: MovieDetailUIView?

    let networkHelper = NetworkHelper()
    let coreDataManager: CoreDataManagerProtocol
    var moviePost: MoviePost?


    init(post: Int, coreDataManager: CoreDataManagerProtocol) {
        self.post = post
        self.coreDataManager = coreDataManager
    }

    func fetchPost(completion: @escaping (_ success: Bool) -> Void) {

        let url = URLToPost(moviePostNumber: String(post))

        networkHelper.requestMoviePost(with: url.apiCallURL) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.moviePost = result
                completion(true)
            }
        }
    }

    func loadImage() {
        guard let url = moviePost?.poster_path else {
            return
        }
        let adressToImage = URLToPosterPath(apiUrl: url)
        guard let urlToImage = URL(string: adressToImage.urlToImage) else { return }
        
        movieDetailView?.updateViews(model: self.moviePost!)
        
        let options = ImageLoadingOptions(
            transition: .fadeIn(duration: 0.33)
        )
        Nuke.loadImage(with: urlToImage, options: options, into: movieDetailView!.posterImageView)
    }
    
    func checkIfLiked() -> Bool {
        do {
            let data = try coreDataManager.requestModels(withId: post)
            if data.count != 0 {
                if data[0].isLiked {return true}
            }
            return false
        } catch {
            return false
        }
    }
    
    func writeLikedMovie(){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        let likedMovie = LikedMovieModel(id: post, isLiked: true)
        coreDataManager.update(with: likedMovie, withAction: .add) { result in
            switch result {
            case .success(.add):
                print("success")
            case .failure(let error):
                print("CD: happens error: \(error.localizedDescription)")
            default:
                break
            }
        }
    }
    
    func deleteLikedMovie(){
        let likedMovie = LikedMovieModel(id: post, isLiked: false)
        coreDataManager.update(with: likedMovie, withAction: .remove) { result in
            switch result {
            case .success(.remove):
                print("success")
            case .failure(let error):
                print("CD: happens error: \(error.localizedDescription)")
            default:
                break
            }
        }
    }
    
    func viewDidDisappear(){
        coordinator?.didFinishMovieDetail()
    }
}
