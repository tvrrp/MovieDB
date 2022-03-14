//
//  MovieLikedViewContoroller.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//

import UIKit

class MovieLikedViewContoroller: UIViewController {
    
    var viewModel: MovieLikedViewModel!
    private var movieCollectionView: UICollectionView
    private var noLikedView: ErrorUiView
    
    init() {
        let movieCollectionViewLayout = UICollectionViewFlowLayout()
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieCollectionViewLayout)
        noLikedView = ErrorUiView(frame: .zero, errorSFSymbolName: "heart.text.square", errorLabelText: "Here will be displayed your liked movies")
        super.init(nibName: nil, bundle: nil)
        movieCollectionView.collectionViewLayout = makeCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchLikedMovie { (bool) in
            switch bool {
            case true:
                displayErrorView()
                setupUI()
            case false:
                displayErrorView()
            }
        }
        view.backgroundColor = .systemBackground
        let leftBarButtonItem = UIBarButtonItem(title: "Movies", style: .plain, target: self, action: #selector(dismissLikedViewController))
        self.parent?.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func dismissLikedViewController() {
        self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem?.isEnabled = true
        viewModel.viewDidDisappear(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.rightBarButtonItem?.isEnabled = false
        viewModel.viewWillAppear()
    }
    
    private func displayErrorView() {
        view.addSubview(noLikedView)
        noLikedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noLikedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noLikedView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noLikedView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            noLikedView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
}

extension MovieLikedViewContoroller {

    func setupUI() {
        viewModel.collectionView = movieCollectionView
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        movieCollectionView.showsVerticalScrollIndicator = false
        movieCollectionView.backgroundColor = .systemBackground

        view.addSubview(movieCollectionView)
        viewModel.setupCollectionView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MovieLikedViewContoroller {

    func makeGridLayoutSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
            ))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.7)
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
