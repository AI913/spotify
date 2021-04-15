//
//  Artist.swift
//  Spotify
//
//  Created by frontarc on 2021/04/01.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
