//
//  ContentView.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI
import SwiftData
import OSLog

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var followingUsers: [FollowingUser]
    
    var body: some View {
        NavigationStack {
            SearchView().padding(.bottom)
            
            Text("Previously saved data")
            List {
                ForEach(followingUsers) { user in
                    VStack(alignment: .leading, content: {
                        Text(user.login).font(.headline)
                    })}
            }
//            .toolbar(content: {
//                Button("Delete data", action: deleteData)
//            })
        }
    }
    
    func deleteData() {
        do {
            try modelContext.delete(model: FollowingUser.self)
        } catch {
            Logger.swiftData.error("Failed to delete students")
        }
    }
}

#Preview {
    ContentView()
}
