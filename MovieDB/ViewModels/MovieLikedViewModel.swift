//
//  MovieLikedViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//

import UIKit
import Nuke

final class MovieLikedViewModel: NSObject {
    
    var coordinator: MovieLikedCoordinator?
    weak var collectionView: UICollectionView?
    
    let networkHelper = NetworkHelper()
    let prefetcher = ImagePrefetcher()
    let coreDataManager: CoreDataManagerProtocol
    
    var movieID = [Int]()
    var movieList = [MoviePost?]()
    
    init(coreDataManager: CoreDataManagerProtocol){
        self.coreDataManager = coreDataManager
    }
    
    func fetchLikedMovie(completion: (Bool) -> Void) {
        do {
            let likedMovies = try coreDataManager.requestModels()

            for item in 0..<likedMovies.count {
                movieID.append(Int(likedMovies[item].id))
            }
            if likedMovies.count != 0 {
                movieList = [MoviePost?](repeating: nil, count: movieID.count)
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            completion(false)
        }
    }
    
    func fetchMovies(ofIndex index: Int) {

        let url = LikedMovieURL(movieID: String(movieID[index]))

        networkHelper.requestMoviePost(with: url.apiCallURL) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                print(url.apiCallURL)
            case .success(let result):
                
                self?.movieList[index] = result

                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }

    private func cancelFetchMovies(ofIndex index: Int) {
        let url = LikedMovieURL(movieID: String(movieID[index]))
        networkHelper.cancelRequestMovies(with: url.apiCallURL)
    }
    
    private func getImageURL(index: Int) -> String {
        guard let url = movieList[index]?.backdrop_path else {
            return ""
        }
        let adressToImage = URLToImage(apiUrl: url)
        return adressToImage.urlToImage
    }

    private func loadImages(with model: MoviePost, with indexPath: IndexPath, with cell: MovieCollectionViewCell) {
        
        cell.updateViewFromMoviesPost(model: model)
        guard let urlToImage = URL(string: getImageURL(index: indexPath.row)) else {
            cell.backdropPathImage.image = UIImage(systemName: "film")
            return }
        let options = ImageLoadingOptions(
            transition: .fadeIn(duration: 0.33)
        )
        Nuke.loadImage(with: urlToImage, options: options, into: cell.backdropPathImage)
    }

    private func prefetchImages(with indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { URL(string: getImageURL(index: $0.row)) }
        prefetcher.startPrefetching(with: urls)
    }
    
    func viewDidDisappear(_ movieLikedViewController: MovieLikedViewContoroller){
        prefetcher.stopPrefetching()
        coordinator?.didFinishMovieLiked(movieLikedViewController)
    }
    
    func setupCollectionView() {
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.prefetchDataSource = self
    }
    
    func movieCellTapped(with index: Int) {
        coordinator?.startDetailVCPresent(with: movieID[index])
    }
    
    func viewWillAppear() {
        var fetchedIDS = [Int]()
        do {
            let likedMovies = try coreDataManager.requestModels()
            for item in 0..<likedMovies.count {
                fetchedIDS.append(Int(likedMovies[item].id))
            }
        } catch {
            print("No data")
        }
        
        if fetchedIDS != movieID {
            let difference = movieID.difference(from: fetchedIDS)
            for item in 0..<difference.count {
                let index = movieID.firstIndex(of: difference[item])
                movieID.remove(at: index!)
                movieList.remove(at: index!)
                collectionView?.deleteItems(at: [IndexPath(row: index!, section: 0)])
            }
        }
        if movieID.count == 0 {
            collectionView?.removeFromSuperview()
        }
    }
}

extension MovieLikedViewModel: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell

        if let model = movieList[indexPath.row] {
            self.loadImages(with: model, with: indexPath, with: cell)
        } else {
            fetchMovies(ofIndex: indexPath.row)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieCellTapped(with: indexPath.row)
    }

}

extension MovieLikedViewModel: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
            fetchMovies(ofIndex: indexPath.row)
        }
        prefetchImages(with: indexPaths)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cancelFetchMovies(ofIndex: indexPath.row)
        }
        let urls = indexPaths.compactMap { URL(string: getImageURL(index: $0.row)) }
        prefetcher.stopPrefetching(with: urls)
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
