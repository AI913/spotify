//
//  Playlist.swift
//  Spotify
//
//  Created by frontarc on 2021/04/01.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
