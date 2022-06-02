//
//  Artist.swift
//  json
//
//  Created by Анастасия Ступникова on 09.05.2022.
//

struct SearchResult: Decodable {
    let results: [TrackData]
    
    static func getTracks(from value: Any) -> [TrackData] {
        guard let trackData = value as? [String: Any] else { return [] }
        guard let results = trackData["results"] as? [[String: Any]] else { return [] }
        
        return results.compactMap { TrackData(result: $0)}
    }
}

struct TrackData: Decodable {
    let country: String?
    let artistName: String?
    let trackName: String?
    
    init(result: [String: Any]) {
        country = result["country"] as? String
        artistName = result["artistName"] as? String
        trackName = result["trackName"] as? String
    }
}
