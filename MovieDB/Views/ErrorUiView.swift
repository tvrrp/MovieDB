//
//  NoConnectionView.swift
//  MovieDB
//
//  Created by Damir Yackupov on 14.03.2022.
//

import UIKit

class ErrorUiView: UIView {
    var errorSFSymbolName: String
    var errorLabelText: String
    
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: errorSFSymbolName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = errorLabelText
        return label
    }()
    
    private lazy var internetStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [errorImageView, errorLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(frame: CGRect, errorSFSymbolName: String, errorLabelText: String) {
        self.errorSFSymbolName = errorSFSymbolName
        self.errorLabelText = errorLabelText
        super.init(frame: .zero)
        setupUI()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        setupUI()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(internetStackView)
        
        NSLayoutConstraint.activate([
            internetStackView.topAnchor.constraint(equalTo: topAnchor),
            internetStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            internetStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            internetStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
