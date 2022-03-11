//
//  MovieDetailScrollView.swift
//  MovieDB
//
//  Created by Damir Yackupov on 05.03.2022.
//

import UIKit

class MovieDetailUIView: UIView {
    
    lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 21
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var movieRuntimeImageView: UIImageView = {
        let image = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 21))
        image.image = UIImage(systemName: "clock.fill")?.withConfiguration(symbolConfig)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var movieRuntimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Длительность"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private lazy var movieRuntimeValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var movieRuntimeCardStackView: UIStackView = {
        let spacer1 = UIView()
        let spacer2 = UIView()
        let stackView = UIStackView(arrangedSubviews: [spacer1, movieRuntimeImageView, movieRuntimeLabel, movieRuntimeValueLabel, spacer2])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        return stackView
    }()
    
    private lazy var movieGenresImageView: UIImageView = {
        let image = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 21))
        image.image = UIImage(systemName: "camera.metering.matrix")?.withConfiguration(symbolConfig)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.text = "Жанр"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private lazy var movieGenresValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var movieGenresCardStackView: UIStackView = {
        let spacer1 = UIView()
        let spacer2 = UIView()
        let stackView = UIStackView(arrangedSubviews: [spacer1, movieGenresImageView, movieGenresLabel, movieGenresValueLabel, spacer2])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        return stackView
    }()
    
    private lazy var movieVoteImageView: UIImageView = {
        let image = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 21))
        image.image = UIImage(systemName: "star.fill")?.withConfiguration(symbolConfig)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var movieVoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private lazy var movieVoteValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var movieVoteCardStackView: UIStackView = {
        let spacer1 = UIView()
        let spacer2 = UIView()
        let stackView = UIStackView(arrangedSubviews: [spacer1,movieVoteImageView, movieVoteLabel, movieVoteValueLabel, spacer2])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        return stackView
    }()
    
    private lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieRuntimeCardStackView, movieGenresCardStackView, movieVoteCardStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 36, weight: .medium)
        return label
    }()
    
    private lazy var movieTaglineLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var movieTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel, movieTaglineLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var lineUIView: LineUiView = {
        let view = LineUiView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(model: MoviePost){
        DispatchQueue.main.async { [self] in
            movieRuntimeValueLabel.text = runtimeValueFromInt(minutes: model.runtime)
            movieGenresValueLabel.text = model.genres[0].name
            movieVoteValueLabel.text = String(model.vote_average)
            movieTitleLabel.text = model.title
            movieTaglineLabel.text = model.tagline
            movieOverviewLabel.text = model.overview
        }
        
    }
    
    private func runtimeValueFromInt(minutes: Int) -> String {
        let h = minutes / 60
        let min = minutes % 60
        return "\(h) ч \(min) мин"
    }

}

extension MovieDetailUIView {
    
    private func setupUI(){
        [posterImageView, movieInfoStackView, movieTitleStackView, lineUIView, movieOverviewLabel].forEach { addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),
            posterImageView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            movieInfoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            movieInfoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            movieInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            movieInfoStackView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            movieInfoStackView.heightAnchor.constraint(equalTo: posterImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            movieTitleStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            movieTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            movieTitleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            lineUIView.topAnchor.constraint(equalTo: movieTitleStackView.bottomAnchor),
            lineUIView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            lineUIView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            lineUIView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            movieOverviewLabel.topAnchor.constraint(equalTo: lineUIView.bottomAnchor),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            movieOverviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

fileprivate class LineUiView: UIView {
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(1.5)
        context!.setStrokeColor(UIColor.systemGray.cgColor)
        context?.move(to: CGPoint(x: 0, y: (self.frame.size.height / 2)))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: (self.frame.size.height / 2)))
        context!.strokePath()
    }
}
