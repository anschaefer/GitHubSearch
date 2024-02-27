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
                await cut.getFollowingUsers(for: "twostraws")
            }
        }
    }

}
