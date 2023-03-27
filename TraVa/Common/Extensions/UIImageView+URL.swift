//
//  UIImageView+URL.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 05.01.2022.
//

import UIKit

public extension UIImageView {
    func download(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }

    func download(from link: String) {
        guard let url = URL(string: link) else { return }
        download(from: url)
    }
}
