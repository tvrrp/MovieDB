//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import UIKit

class MovieListViewController: UIViewController {

    var viewModel: MovieListViewModel!

    private var movieCollectionView: UICollectionView

    init() {
        let movieCollectionViewLayout = UICollectionViewFlowLayout()
//        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieCollectionViewLayout)
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieCollectionViewLayout)
        super.init(nibName: nil, bundle: nil)
        movieCollectionView.collectionViewLayout = makeCollectionViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       // viewModel.fetchMovies()

        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Movies", style: .plain, target: self, action: #selector(buttonTappedAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Liked", style: .plain, target: self, action: #selector(buttonTappedAction))

        navigationItem.leftBarButtonItem?.imageInsets = .init(top: 0, left: 50, bottom: 0, right: 0)

        setupUI()
    }

    override func viewWillLayoutSubviews() {
        movieCollectionView.frame = view.frame
    }

    @objc func buttonTappedAction() {

    }

}

extension MovieListViewController {

    func setupUI() {
//        movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
//        movieCollectionView.dataSource = viewModel
//        movieCollectionView.delegate = viewModel
        viewModel.collectionView = movieCollectionView

        movieCollectionView.backgroundColor = .systemBackground
        movieCollectionView.isSkeletonable = true
        movieCollectionView.isUserInteractionDisabledWhenSkeletonIsActive = false

        view.addSubview(movieCollectionView)
        viewModel.setupCollectionView()
    }
}

extension MovieListViewController {

    func makeGridLayoutSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
            ))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10

        return section
    }

    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, _ in
            return self?.makeGridLayoutSection()
        }
    }

    func makeCollectionView() -> UICollectionView {
        UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )

    }
}
