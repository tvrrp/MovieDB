//
//  PopularMovieCell.swift
//  MovieDB
//
//  Created by Damir Yackupov on 01.03.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    static var identifier = "PopularMovieCell"
    
    lazy var backdropPathImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 21
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, filmInfoStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filmInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [voteAverageLabel, releaseDateLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    func updateViewFromMovies(model: Movies?){
        
        let imageAttachment = NSTextAttachment()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14)
        imageAttachment.image = UIImage(systemName: "star.fill")?.withConfiguration(imageConfig).withTintColor(.systemYellow)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(model?.vote_average ?? 0)/10"))
        
        titleLabel.text = model?.title ?? "No title"
        voteAverageLabel.attributedText = fullString
        releaseDateLabel.text = model?.release_date ?? ""
    }
    
    func updateViewFromMoviesPost(model: MoviePost?){
        
        let imageAttachment = NSTextAttachment()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14)
        imageAttachment.image = UIImage(systemName: "star.fill")?.withConfiguration(imageConfig).withTintColor(.systemYellow)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(model?.vote_average ?? 0)/10"))
        
        titleLabel.text = model?.title ?? "No title"
        voteAverageLabel.attributedText = fullString
        releaseDateLabel.text = model?.release_date ?? ""
    }
    
    private func setupUI(){
        
        [backdropPathImage, labelsStackView].forEach {contentView.addSubview($0)}
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backdropPathImage.topAnchor.constraint(equalTo: topAnchor),
            backdropPathImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropPathImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropPathImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: backdropPathImage.bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}

