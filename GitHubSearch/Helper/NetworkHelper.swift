//
//  NetworkHelper.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import Foundation

struct NetworkHelper {
    
    func createUrlSession(sessionName sessionDescription: String) -> URLSession {
        let session = URLSession(configuration:.default)
        session.sessionDescription = sessionDescription
        
        return session
    }
    
    func createRequest(for url: URL, withMethod httpMethod: HttpMethods) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue(Bundle.main.infoDictionary?["GITHUB_API_KEY"] as? String ?? "", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
