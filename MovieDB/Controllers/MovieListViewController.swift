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
    private var noConnectionView: ErrorUiView

    init() {
        let movieCollectionViewLayout = UICollectionViewFlowLayout()
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieCollectionViewLayout)
        noConnectionView = ErrorUiView(frame: .zero, errorSFSymbolName: "wifi.slash", errorLabelText: "No Internet Connection")
        super.init(nibName: nil, bundle: nil)
        movieCollectionView.collectionViewLayout = makeCollectionViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.title
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectionRestored), name: NSNotification.Name(rawValue: "Connection satisfied"), object: nil)
        
        viewModel.checkForConnection { Bool in
            switch Bool{
            case true:
                setupUI()
            case false:
                showNoConnectionView()
            }
        }
       
        
    }
    
    @objc func connectionRestored() {
        noConnectionView.removeFromSuperview()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }

    @objc func showLikedViewController() {
        viewModel.showLikedViewController()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func showNoConnectionView() {

        view.addSubview(noConnectionView)
        noConnectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noConnectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noConnectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noConnectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            noConnectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

}

extension MovieListViewController {

    func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Liked", style: .plain, target: self, action: #selector(showLikedViewController))
        
        
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

extension MovieListViewController {

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
