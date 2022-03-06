//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import UIKit
import SkeletonView

class MovieListViewModel: NSObject {

    var coordinator: MovieListCoordinator?
    weak var collectionView: UICollectionView?

    var movieList = [Movies]()
    var posterList = [UIImage]()
    let networkHelper = NetworkHelper()
    let imageLoader = ImageLoader()
    let moviesURL = URLFactory(moviePageNumber: nil)

    let title = "Movies"


    func fetchMovies() {

        networkHelper.requestMovies(with: moviesURL.apiCallURL) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.movieList = result.results
                //  print(self?.movieList)
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                    self?.collectionView?.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
                }
            }
        }
    }
    
    private func loadImages(with model: Movies, with indexPath: IndexPath, with cell: MovieCollectionViewCell){
        
        var imagePoster = UIImage(systemName: "film")
        
        let adressToImage = URLToImage(apiUrl: model.backdrop_path)

        guard let urlToImage = URL(string: adressToImage.urlToImage) else { return }
        
        let token = imageLoader.loadImage(urlToImage) { result in
            do {
                let image = try result.get()
                imagePoster = image
            } catch {
                print(error)
            }
        }
        
        cell.onReuse = {
            if let token = token {
                self.imageLoader.cancelLoad(token)
            }
        }
        cell.updateViewFromModel(model: model, poster: imagePoster!)
        collectionView?.reloadItems(at: [indexPath])
    }

    func movieCellTapped() {
        coordinator?.startDetailVCPresent()
    }
    
    func setupCollectionView() {
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
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
        if movieList.isEmpty {
            return cell
        } else {
            let model = movieList[indexPath.row]
            
            var imagePoster = UIImage(systemName: "film")
            
            let adressToImage = URLToImage(apiUrl: model.backdrop_path)

            guard let urlToImage = URL(string: adressToImage.urlToImage) else { return cell}
            
            DispatchQueue.main.async { [self] in
                let token = imageLoader.loadImage(urlToImage) { result in
                    do {
                        let image = try result.get()
                        imagePoster = image
                    } catch {
                        print(error)
                    }
                }
                
                cell.onReuse = {
                    if let token = token {
                        self.imageLoader.cancelLoad(token)
                    }
                }
                cell.updateViewFromModel(model: model, poster: imagePoster!)
            }
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieCellTapped()
    }

}
