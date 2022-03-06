//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var scrollView: MovieDetailScrollView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    init() {
        scrollView = MovieDetailScrollView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        scrollView.frame = view.frame
    }
    

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
    }

}
