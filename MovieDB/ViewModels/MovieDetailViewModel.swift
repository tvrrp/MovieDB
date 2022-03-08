//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

class MovieDetailViewModel {
    
    var coordinator: MovieDetailCoordinator?
    var post: Int
    weak var movieDetailView: MovieDetailUIView?
    
    let networkHelper = NetworkHelper()
    
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
//                let imageTest45 = UIImage(systemName: "film")
                DispatchQueue.main.async {
                    
                    guard let urlToPoster = URL(string: URLToPosterPath(apiUrl: result.poster_path).urlToImage) else {return}
                    self?.movieDetailView?.posterImageView.kf.indicatorType = .activity
                    self?.movieDetailView?.posterImageView.kf.setImage(with: urlToPoster, completionHandler: { (image) in
                        self?.movieDetailView?.updateViews(with: result)
                    })
                }
            }
        }
    }
    
}
