//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import UIKit
import SkeletonView
import Kingfisher

class MovieListViewModel: NSObject {

    var coordinator: MovieListCoordinator?
    weak var collectionView: UICollectionView?

    var movieList: [Movies?] = [Movies?](repeating: nil, count: 1)
    let networkHelper = NetworkHelper()
    let imageLoader = ImageLoader()

    let title = "Movies"
    let pageNumber = Array(1...32576)


    func fetchMovies(ofIndex index: Int) {

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
                    self?.collectionView?.reloadData()
                }
            }
        }
    }

    private func cancelFetchMovies(ofIndex index: Int) {
        let url = URLFactory(moviePageNumber: String(pageNumber[index]))
        networkHelper.cancelRequestMovies(with: url.apiCallURL)
    }

    private func loadImages(with model: Movies, with indexPath: IndexPath, with cell: MovieCollectionViewCell) {

        var imagePoster = UIImage(systemName: "film")

        guard let url = model.backdrop_path else {
            cell.updateViewFromModel(model: model)
            return
        }
        let adressToImage = URLToImage(apiUrl: url)
        guard let urlToImage = URL(string: adressToImage.urlToImage) else { return }

        cell.backdropPathImage.kf.setImage(with: urlToImage, placeholder: imagePoster)
        cell.updateViewFromModel(model: model)

    }

    func movieCellTapped() {
        coordinator?.startDetailVCPresent()
    }

    func setupCollectionView() {
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.prefetchDataSource = self
    }

}

extension MovieListViewModel: SkeletonCollectionViewDataSource, UICollectionViewDelegate {

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MovieCollectionViewCell.identifier
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        cell.isSkeletonable = true
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) {
        let cell = cell as? MovieCollectionViewCell
        cell?.isSkeletonable = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieList.isEmpty {
            return 20
        } else {
            return movieList.count
        }
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
        movieCellTapped()
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

    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cancelFetchMovies(ofIndex: indexPath.row)
        }
    }
}
