//
//  AuthResponse.swift
//  Spotify
//
//  Created by frontarc on 2021/04/02.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
}
