//
//  Artist.swift
//  json
//
//  Created by Анастасия Ступникова on 09.05.2022.
//

struct SearchResult: Decodable {
    let results: [TrackData]
}

struct TrackData: Decodable {
    let country: String?
    let artistName: String?
    let trackName: String?
}
