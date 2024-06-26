//
//  MovieCell.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Domain
import UIKit
import SnapKit

final class MovieCell: UICollectionViewCell {
    
    private enum Metrics {
        static let spaceBetweenComponents: CGFloat = 9
    }
    
    static let identifier = "MovieCell"
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let overviewLabel = UILabel()
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            guard let posterPath = movie.posterPath else { return }

            self.imageView.imageFromUrl(urlString: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/" + posterPath)
            self.imageView.clipsToBounds = true
            self.nameLabel.text = movie.title
            self.overviewLabel.text = movie.overview
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.alpha = self.isHighlighted ? 0.5 : 1.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.setConfig()
        self.addSubviews()
        self.setConstraints()
    }
    
    private func setConfig() {
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.imageView.layer.cornerRadius = 12
        self.imageView.clipsToBounds = true
        
        self.overviewLabel.textColor = .systemGray
        self.overviewLabel.numberOfLines = 2
        
        self.nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        self.nameLabel.numberOfLines = 2
        
        self.backgroundColor = UIColor(named: "SecondColor")
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(overviewLabel)
    }
    
    private func setConstraints() {
        
        self.imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        self.nameLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(Metrics.spaceBetweenComponents)
            make.left.equalTo(self.imageView.snp.right).offset(Metrics.spaceBetweenComponents)
        }
        self.overviewLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Metrics.spaceBetweenComponents)
            make.left.equalTo(self.imageView.snp.right).offset(Metrics.spaceBetweenComponents)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            make.bottom.equalToSuperview().inset(Metrics.spaceBetweenComponents)
        }
    }
}
