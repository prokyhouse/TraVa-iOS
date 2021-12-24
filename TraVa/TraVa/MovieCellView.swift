//
//  MovieCellView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

protocol IMovieCellView {
	func set(movie: Movie)
}

final internal class MovieCellView: UICollectionViewCell {

	private let poster = UIImageView()

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		self.addSubviews()
		self.setConstraint()
		self.setConfig()
	}

	private func addSubviews() {
		self.addSubview(self.poster)
	}

	private func setConfig() {
		self.backgroundColor = UIColor.lightGray
		self.layer.cornerRadius = 12
	}

	private func setConstraint() {
		self.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		self.poster.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}

extension MovieCellView: IMovieCellView {
	func set(movie: Movie) {
//		self.cellTitle.text = event.title
		let posterURL = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/" + movie.posterPath
		let templateURL = "https://i.pinimg.com/originals/30/d5/38/30d53895b7337958e79aff2e974c7a1f.jpg"

		self.poster.imageFromUrl(urlString: posterURL ?? templateURL)

		self.poster.clipsToBounds = true
	}
}

extension UIImageView {
public func imageFromUrl(urlString: String) {
	if let url = NSURL(string: urlString) {
		let request = NSURLRequest(url: url as URL)
		NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response: URLResponse?, data: Data?, error: Error?) -> Void in
			if let imageData = data as NSData? {
				self.image = UIImage(data: imageData as Data)
			}
		}
	}
  }
}
