//
//  GitHubSearchApp.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI
import SwiftData

@main
struct GitHubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FollowingUser.self)
    }
}
