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

	private static var API_KEY = "api_key=2e774b038b2dc15a1db7397f1b6b63a7"

	private static var POPULAR_URL = "https://api.themoviedb.org/3/movie/popular?"
	private static var UPCOMING_URL = "https://api.themoviedb.org/3/movie/upcoming?"

	private static var language = "&language=ru-RU"
	private static var page = "&page=1"

	private var requestURL = POPULAR_URL + API_KEY + language + page
	private var upcomingRequestURL = UPCOMING_URL + API_KEY + language + page

	private let session: URLSession
	private let upcomingSession: URLSession

	init(configuration: URLSessionConfiguration? = nil) {
		if let configuration = configuration {
			self.session = URLSession(configuration: configuration)
			self.upcomingSession = URLSession(configuration: configuration)
		}
		else {
			self.session = URLSession(configuration: URLSessionConfiguration.default)
			self.upcomingSession = URLSession(configuration: URLSessionConfiguration.default)
		}
	}

	func loadData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
		guard let url = URL(string: requestURL) else { fatalError("Некорректный URL") }

		print("request is: " + requestURL)

		let request = URLRequest(url: url)
		self.session.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
			}
			if let data = data {
				do {
					let result = try JSONDecoder().decode(T.self, from: data)
					print("[NETWORK] \(response)")
					completion(.success(result))
				}
				catch {
					completion(.failure(error))
				}
			}
		}.resume()
	}

	func loadUpcomingMovies<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
		guard let url = URL(string: upcomingRequestURL) else { fatalError("Некорректный URL") }

		print("request is: " + requestURL)

		let request = URLRequest(url: url)
		self.upcomingSession.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
			}
			if let data = data {
				do {
					let result = try JSONDecoder().decode(T.self, from: data)
					print("[NETWORK // UPCOMING] \(response)")
					completion(.success(result))
				}
				catch {
					completion(.failure(error))
				}
			}
		}.resume()
	}

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

final class URLBuilder {
	enum Parameters: String {
		case language = ""
	}
}
