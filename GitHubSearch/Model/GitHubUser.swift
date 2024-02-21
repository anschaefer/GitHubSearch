//
//  GitHubUser.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

struct GitHubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
    let twitterUsername: String
    let name: String
    let followers: Int
    let following: Int
    let publicRepos: Int
    let company: String
    
}
