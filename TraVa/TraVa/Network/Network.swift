//
//  Network.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation

//protocol INetworkService
//{
//	func loadData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
//	func loadRandomImage(completion: @escaping (Result<Data, Error>) -> Void)
//}
//
final class NetworkService {

	private static var API_KEY = "2e774b038b2dc15a1db7397f1b6b63a7"
//	private let session: URLSession
//
//	init(configuration: URLSessionConfiguration? = nil) {
//		if let configuration = configuration {
//			self.session = URLSession(configuration: configuration)
//		}
//		else {
//			self.session = URLSession(configuration: URLSessionConfiguration.default)
//		}
//	}
//
//	func loadData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
//		guard let url = URL(string: "https://thatcopy.pw/catapi/rest/") else { fatalError("Сообщение") }
//
//		let request = URLRequest(url: url)
//		self.session.dataTask(with: request) { data, response, error in
//			if let error = error {
//				completion(.failure(error))
//			}
//			if let data = data {
//				do {
//					let result = try JSONDecoder().decode(T.self, from: data)
//					print("[NETWORK] \(response)")
//					completion(.success(result))
//				}
//				catch {
//					completion(.failure(error))
//				}
//			}
//		}.resume()
//	}
//
//	func loadRandomImage(completion: @escaping (Result<Data, Error>) -> Void) {
//		self.loadData { (result: Result<UrlModelDTO, Error>) in
//			switch result {
//			case .success(let model):
//				guard let url = URL(string: model.url) else { fatalError() }
//				let request = URLRequest(url: url)
//				//		guard let url = URL(string: "https://thatcopy.github.io/catAPI/imgs/jpg/4ca6ff3.jpg") else { assert(false, "Кривой УРЛ") } // fatalError ЗАПРЕЩЕН!
//
//				self.session.downloadTask(with: request) { url, response, error in
//					if let error = error {
//						completion(.failure(error))
//					}
//
//					if let url = url {
//						if let result = try? Data(contentsOf: url) {
//							completion(.success(result))
//						}
//					}
//				}.resume()
//			default: return
//			}
//		}
//	}
}
