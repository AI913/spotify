//
//  SearchResult.swift
//  Spotify
//
//  Created by 招耀華 on 14/4/2021.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
