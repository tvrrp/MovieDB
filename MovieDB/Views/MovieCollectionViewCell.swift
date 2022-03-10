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
    
    private var blurBackDropView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView()
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
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
        label.textColor = .white
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
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .white
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func updateViewFromModel(model: Movies, poster: UIImage){
        
        let imageAttachment = NSTextAttachment()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14)
        imageAttachment.image = UIImage(systemName: "star.fill")?.withConfiguration(imageConfig).withTintColor(.white)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(model.vote_average)/10"))
        
        titleLabel.text = model.title
        voteAverageLabel.attributedText = fullString
        releaseDateLabel.text = model.release_date
        backdropPathImage.image = poster
    }
    
    private func setupUI(){
        
        addSubview(backdropPathImage)
        backdropPathImage.addSubview(blurBackDropView)
        blurBackDropView.contentView.addSubview(labelsStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backdropPathImage.topAnchor.constraint(equalTo: topAnchor),
            backdropPathImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropPathImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropPathImage.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            blurBackDropView.topAnchor.constraint(equalTo: backdropPathImage.centerYAnchor, constant: 20),
            blurBackDropView.leadingAnchor.constraint(equalTo: backdropPathImage.leadingAnchor),
            blurBackDropView.trailingAnchor.constraint(equalTo: backdropPathImage.trailingAnchor),
            blurBackDropView.bottomAnchor.constraint(equalTo: backdropPathImage.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: blurBackDropView.topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: blurBackDropView.leadingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: blurBackDropView.trailingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: blurBackDropView.bottomAnchor, constant: -10),
        ])
    }
}

