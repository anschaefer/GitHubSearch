//
//  PerformanceTests.swift
//  GitHubSearchUITests
//
//  Created by André Schäfer on 26.02.24.
//

import XCTest
@testable import GitHubSearch

final class PerformanceTests: XCTestCase {
    
    func testPerformanceRequestUser() throws {
        // Arrange
        let cut = UserView(login: "twostraws")
        
        // Act/Assert
        
        measure {
            Task {
                await cut.requestUser(with:"twostraws")
            }
        }
    }
    
    func testPerformanceRequestUsers() throws {
        // Arrange
        let cut = FollowingUserView(login: "twostraws")
        
        // Act/Assert
        measure {
            Task {
               try await cut.getFollowingUsers(for: "twostraws")
            }
        }
    }
    
    func testPaginationPerformance() async {
        // Arrange
        let endpoint = "https://api.github.com/users/manniL/following"
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
        measure {
            let numberOfPages = NetworkHelper.getPaginationLastPage(for: urlResponse)
        }
        

    }
}
