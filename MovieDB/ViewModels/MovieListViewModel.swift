//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import UIKit

class MovieListViewModel: NSObject {
    
    
    
    var movieList = [Movies]()
    let networkHelper = NetworkHelper()
    let moviesURL = URLFactory(moviePageNumber: nil)
    
    let title = "Latest movies"
    
    
    func fetchMovies(collectionView: UICollectionView) {
        
        networkHelper.requestMovies(with: moviesURL.apiCallURL) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.movieList = result.results
                //print(self?.movieList)
                DispatchQueue.main.async {
                   // collectionView.collectionViewLayout = self!.makeCollectionViewLayout()
                    collectionView.reloadData()
                }
                
            }
        }
    }
    
//    func setupCollectionView(){
//        
//        collectionView.reloadData()
//        
//    }
    
}

extension MovieListViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        let model = movieList[indexPath.row]
        cell.updateViewFromModel(model: model)
        return cell
    }
}
