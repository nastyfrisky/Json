//
//  NetworkManager.swift
//  json
//
//  Created by Анастасия Ступникова on 09.05.2022.
//
import Foundation
import Alamofire

enum NetworkError: String, Error {
    case invalidURL = "Invalid URL"
    case noData = "No results"
    case decodingError = "Decoding error"
}

class NetworkManager {
    
    // MARK: - Public Methods

    func searchTracks(query: String, completion: @escaping(Result<[TrackData], NetworkError>) -> Void) {
        let url = "https://itunes.apple.com/search"
        
        guard var components = URLComponents(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        components.queryItems = [URLQueryItem(name: "term", value: query)]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let trackList = SearchResult.getTracks(from: value)
                    
                    if trackList.isEmpty {
                        completion(.failure(.noData))
                    } else {
                        completion(.success(trackList))
                    }
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
}
