//
//  MovieDetailScrollView.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

class MovieDetailScrollView: UIScrollView {
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "poster")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 21
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isSkeletonable = true
        return image
    }()
    
    private lazy var movieRuntimeImageView: UIImageView = {
        let image = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 21)
        image.image = UIImage(systemName: "clock.fill")?.withConfiguration(symbolConfig)
        return image
    }()
    
    private lazy var movieRuntimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Длительность"
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private lazy var movieRuntimeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "2ч 40 мин"
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var movieRuntimeCardStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [spacer, movieRuntimeImageView, movieRuntimeLabel, movieRuntimeValueLabel])
        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        return stackView
    }()
    
    private lazy var movieGenresImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.metering.matrix")
        return image
    }()
    
    private lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.text = "Жанр"
        return label
    }()
    
    private lazy var movieGenresValueLabel: UILabel = {
        let label = UILabel()
        label.text = "мультфильм"
        return label
    }()
    
    private lazy var movieGenresCardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieGenresImageView, movieGenresLabel, movieGenresValueLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        return stackView
    }()
    
    private lazy var movieVoteImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star.fill")
        return image
    }()
    
    private lazy var movieVoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг"
        return label
    }()
    
    private lazy var movieVoteValueLabel: UILabel = {
        let label = UILabel()
        label.text = "7.7/10"
        return label
    }()
    
    private lazy var movieVoteCardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieVoteImageView, movieVoteLabel, movieVoteValueLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        return stackView
    }()
    
    private lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieRuntimeCardStackView, movieGenresCardStackView, movieVoteCardStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.setCustomSpacing(10, after: movieRuntimeCardStackView)
        stackView.setCustomSpacing(10, after: movieGenresCardStackView)
//        stackView.spacing = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MovieDetailScrollView {
    
    private func setupUI(){
        [posterImageView, movieInfoStackView].forEach { addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),
            posterImageView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            movieInfoStackView.topAnchor.constraint(equalTo: topAnchor),
            movieInfoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            movieInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            movieInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
        ])
    }
    
}
