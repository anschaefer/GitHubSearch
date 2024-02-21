//
//  GHError.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import Foundation

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
