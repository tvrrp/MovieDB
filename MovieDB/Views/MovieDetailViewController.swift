//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var viewModel: MovieDetailViewModel!
    private let coreDataManager = CoreDataManager()
    let likedButtonImage = UIImage(systemName: "")
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var contentView: MovieDetailUIView = {
        let view = MovieDetailUIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        displayActivityIndicator()
        
        viewModel.fetchPost() { [weak self] (success) -> Void in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self?.setupUI()
                    self?.viewModel.loadImage()
                    if self?.viewModel.checkIfLiked() == true {
                        self?.updateBarButton(isLiked: true)
                    } else { self?.updateBarButton(isLiked: false)}
                    self?.activityIndicator.stopAnimating()
                })
            }
        }
    }
    
    private func updateBarButton (isLiked: Bool) {
        if isLiked == true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart.fill"), style: .plain, target: self, action: #selector(likeMovieEvent))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(likeMovieEvent))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    private func displayActivityIndicator(){
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func likeMovieEvent(){
        if viewModel.checkIfLiked() == true {
            viewModel.deleteLikedMovie()
            updateBarButton(isLiked: false)
        } else {
            viewModel.writeLikedMovie()
            updateBarButton(isLiked: true)
        }
    }
    

    private func setupUI() {
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(likeMovieEvent))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        viewModel.movieDetailView = contentView
        setupConstraints()
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30),
        ])
        
        
    }
}
