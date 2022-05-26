//
//  NetworkManager.swift
//  json
//
//  Created by Анастасия Ступникова on 09.05.2022.
//
import Foundation

class NetworkManager {
    
    // MARK: - Public Methods
    
    func searchTracks(query: String, completion: @escaping (SearchResult?, String?) -> Void) {
        let url = "https://itunes.apple.com/search"
        
        guard var components = URLComponents(string: url) else { return }
        
        components.queryItems = [URLQueryItem(name: "term", value: query)]
        
        guard let url = components.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.callCompletion(completion: completion, result: nil, error: error?.localizedDescription)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                if result.results.isEmpty {
                    self.callCompletion(completion: completion, result: nil, error: "Search result is empty")
                } else {
                    self.callCompletion(completion: completion, result: result, error: nil)
                }
            } catch let error {
                self.callCompletion(completion: completion, result: nil, error: error.localizedDescription)
            }
           
        }.resume()
    }
    
    // MARK: - Private Methods
    
    private func callCompletion(completion: @escaping (SearchResult?, String?) -> Void, result: SearchResult?, error: String?) {
        DispatchQueue.main.async {
            completion(result, error)
        }
    }
}
