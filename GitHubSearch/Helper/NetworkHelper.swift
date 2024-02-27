//
//  NetworkHelper.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import Foundation
import OSLog

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
    
    func getPaginationLastPage(for response: URLResponse) -> Int? {
        os_signpost(.begin, log: OSLog.pointsOfInterest, name: "getPaginationLastPage")
        defer {
            os_signpost(.end, log: OSLog.pointsOfInterest, name: "getPaginationLastPage")
        }
        var pages: Set<Int> = Set()
        
        let httpResponse = response as? HTTPURLResponse
        if let linkStr = httpResponse?.value(forHTTPHeaderField: "Link") {
            let strArr = linkStr.split(separator: " ")
            
            strArr.forEach {
                let part = $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if let lastNumber = part.last?.wholeNumberValue {
                    pages.insert(lastNumber)
                }
            }
        }
        
        return pages.max()
    }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let pointsOfInterest = OSLog(subsystem: subsystem, category: .pointsOfInterest)
}
