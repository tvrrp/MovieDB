//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import UIKit
import Kingfisher

final class MovieListViewModel: NSObject {

    var coordinator: MovieListCoordinator?
    weak var collectionView: UICollectionView?

    var movieList: [Movies?] = [Movies?](repeating: nil, count: 1)
    let networkHelper = NetworkHelper()

    let title = "Movies"
    let pageNumber = Array(1...500)


    func fetchMovies(ofIndex index: Int) {

        if index > 499 {
            return
        }

        let url = URLFactory(moviePageNumber: String(pageNumber[index]))

        networkHelper.requestMovies(with: url.apiCallURL) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                print(url.apiCallURL)
            case .success(let result):

                if index == 0 {
                    self?.movieList = result.results
                } else {
                    self?.movieList.append(contentsOf: result.results)
                }

                DispatchQueue.main.async {
                    let start = ((self?.pageNumber[index])! * 20) - 20
                    let end = (self?.movieList.count)!
                    var indexPaths = [IndexPath]()
                    
                    for item in stride(from: start, to: end, by: 1) {
                        let indexPath = IndexPath(row: item, section: 0)
                        indexPaths.append(indexPath)
                    }
                    
                    self?.collectionView?.insertItems(at: indexPaths)
                }
            }
        }
    }

    private func cancelFetchMovies(ofIndex index: Int) {

        if index > 499 {
            return
        }

        let url = URLFactory(moviePageNumber: String(pageNumber[index]))
        networkHelper.cancelRequestMovies(with: url.apiCallURL)
    }
    
    private func getImageURL(index: Int) -> String {
        guard let url = movieList[index]?.backdrop_path else {
            return ""
        }
        let adressToImage = URLToImage(apiUrl: url)
        return adressToImage.urlToImage
    }

    private func loadImages(with model: Movies, with indexPath: IndexPath, with cell: MovieCollectionViewCell) {
        guard let urlToImage = URL(string: getImageURL(index: indexPath.row)) else { return }

        KingfisherManager.shared.retrieveImage(with: urlToImage) { result in
            switch result {
            case .failure(let error):
                print(error)
                cell.updateViewFromModel(model: model, poster: UIImage(systemName: "film")!)
            case .success(let image):
                cell.updateViewFromModel(model: model, poster: image.image)
            }
        }
    }

    private func prefetchImages(with indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { URL(string: getImageURL(index: $0.row)) }
        ImagePrefetcher(urls: urls).start()
    }


    func movieCellTapped(with index: Int) {
        guard let post = movieList[index]?.id else { return }
        coordinator?.startDetailVCPresent(with: post)
    }

    func setupCollectionView() {
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.prefetchDataSource = self
    }

}

extension MovieListViewModel: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell

        if let model = movieList[indexPath.row] {
            self.loadImages(with: model, with: indexPath, with: cell)
        } else {
            if Int(indexPath.row / 19) == 0 {
                fetchMovies(ofIndex: 0)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieCellTapped(with: indexPath.row)
    }

}

extension MovieListViewModel: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {

            if indexPath.row < 19 {
                fetchMovies(ofIndex: 1)
            } else {
                fetchMovies(ofIndex: Int(indexPath.row / 19) + 1)
            }
        }
        prefetchImages(with: indexPaths)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cancelFetchMovies(ofIndex: indexPath.row)
        }
        let urls = indexPaths.compactMap { URL(string: getImageURL(index: $0.row)) }
        ImagePrefetcher(resources: urls).stop()
    }
}
