//
//  NetworkHelperTests.swift
//  GitHubSearchTests
//
//  Created by André Schäfer on 28.02.24.
//

import XCTest
@testable import GitHubSearch

final class NetworkHelperTests: XCTestCase {

    func testPaginationPerformance() async {
        // Arrange
        let endpoint = "https://api.github.com/users/anschaefer/following"
        var urlResponse = URLResponse()
        
        guard let url = URL(string: endpoint) else {
            print("Invalid url")
            return
        }
        
        let session = URLSession(configuration:.default)
        
        do {
            let (_, response) = try await session.data(from: url)
            urlResponse = response
        } catch {
            // Test will fail anyway
        }
        
        // Act
        let numberOfPages = NetworkHelper.getPaginationLastPage(for: urlResponse)
        
        // Assert
        assert(numberOfPages == 2)
    }

}
