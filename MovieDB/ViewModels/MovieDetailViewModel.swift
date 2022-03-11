//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import Combine
import UIKit
import Nuke

final class MovieDetailViewModel {

    var coordinator: MovieDetailCoordinator?
    var post: Int
    weak var movieDetailView: MovieDetailUIView?

    let networkHelper = NetworkHelper()
    var moviePost: MoviePost?


    init(post: Int) {
        self.post = post
    }

    func fetchPost(completion: @escaping (_ success: Bool) -> Void) {

        let url = URLToPost(moviePageNumber: String(post))

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
    
    func viewDidDisappear(){
        coordinator?.didFinishMovieDetail()
    }
}
