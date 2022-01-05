//
//  UIImageView+URL.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 05.01.2022.
//

import UIKit

extension UIImageView {
	public func imageFromUrl(urlString: String) {
		if let url = NSURL(string: urlString) {
			let request = NSURLRequest(url: url as URL)
			NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (_: URLResponse?, data: Data?, _: Error?) -> Void in
				if let imageData = data as NSData? {
					self.image = UIImage(data: imageData as Data)
				}
			}
		}
	}
}
