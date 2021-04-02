//
//  SettingsModels.swift
//  Spotify
//
//  Created by frontarc on 2021/04/02.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
    
    
}

struct Option {
    let title: String
    let handler: () -> Void
}


