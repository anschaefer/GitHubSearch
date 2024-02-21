//
//  FollowingUser.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftData

@Model
class FollowingUser: Codable {
    
    enum CodingKeys: CodingKey {
        case login
        case avatarUrl
    }
    
    var login: String
    var avatarUrl: String
    
    init(login: String, avatarUrl: String) {
        self.login = login
        self.avatarUrl = avatarUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decode(String.self, forKey: .login)
        avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(login, forKey: .login)
        try container.encode(avatarUrl, forKey: .avatarUrl)
    }
}

