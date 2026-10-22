//
//  ActorViewCell.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 27.12.2021.
//

import Domain
import UIKit
import SnapKit

final class ActorCellView: UICollectionViewCell {
    
    private enum Metrics {
        static let spaceBetweenComponents: CGFloat = 9
        static let nameHeight: CGFloat = 36
    }
    
    static let identifier = "ActorCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    var actor: Cast? {
        didSet {
            guard let actor = actor else { return }
            self.nameLabel.text = actor.name
            if let profileURL = actor.profileURL {
                self.imageView.imageFromUrl(urlString: profileURL.absoluteString)
            } else {
                self.imageView.image = UIImage(named: "ActorTemplate")
            }
            self.imageView.clipsToBounds = true
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
        self.imageView.clipsToBounds = true
        
        self.imageView.layer.cornerRadius = 16

        self.nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        self.nameLabel.textColor = .white
        self.nameLabel.textAlignment = .center
        self.nameLabel.numberOfLines = 2
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        
        self.layer.cornerRadius = 16
    }
    
    private func addSubviews() {
        self.addSubview(imageView)
        self.imageView.addSubview(nameLabel)
    }
    
    private func setConstraints() {
        
        self.imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width).multipliedBy(1.5)
        }

        self.nameLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(Metrics.nameHeight)
        }
    }
}
