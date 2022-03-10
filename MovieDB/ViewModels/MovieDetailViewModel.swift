//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit
import Kingfisher

final class MovieDetailViewModel {

    var coordinator: MovieDetailCoordinator?
    var post: Int
    weak var movieDetailView: MovieDetailUIView?
    weak var movieDetailScrollView: UIScrollView?

    let networkHelper = NetworkHelper()
    var moviePost: MoviePost?

    init(post: Int) {
        self.post = post
    }

    func fetchPost() {

        let url = URLToPost(moviePageNumber: String(post))

        networkHelper.requestMoviePost(with: url.apiCallURL) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.moviePost = result
                self?.loadImage()
            }
        }
    }

    private func loadImage() {
        guard let url = moviePost?.poster_path else {
            return
        }
        let adressToImage = URLToPosterPath(apiUrl: url)
        guard let urlToImage = URL(string: adressToImage.urlToImage) else { return }

        KingfisherManager.shared.retrieveImage(with: urlToImage) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.movieDetailView?.updateViews(model: self.moviePost!, poster: UIImage(systemName: "film")!)
            case .success(let image):
                self.movieDetailView?.updateViews(model: self.moviePost!, poster: image.image)
            }
        }
    }
    
    func viewDidDisappear(){
        coordinator?.didFinishMovieDetail()
    }
}
