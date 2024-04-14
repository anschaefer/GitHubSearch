//
//  FollowingUserView.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI
import SwiftData
import OSLog

struct FollowingUserView: View {
    @Environment(\.modelContext) var modelContext
    @State var followingUsers = [FollowingUser]()
    
    var login: String
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(followingUsers, id: \.login) { user in
                    NavigationLink(user.login, destination: UserView(login: user.login))
                        .font(.headline)
                        .navigationTitle("Following Users")
                }
            }
            .listStyle(.inset)
            
        }.task {
            do {
                try await getFollowingUsers(for: login)
            } catch {
                
            }
        }
        .toolbar(content: {
            NavigationLink("Search", destination: ContentView())
        })
    }
    
    
    func getFollowingUsers(for login: String) async throws {
        Logger.methodCall.info("Entering getFollowingUsers")
        
        defer {
            Logger.methodCall.info("Leaving getFollowingUsers")
        }
        
        let endpoint = "https://api.github.com/users/\(login)/following"
        
        
        guard let url = URL(string: endpoint) else {
            print("Invalid url")
            return
        }
        
        let session = NetworkHelper.createUrlSession(sessionName: "Following User Session")
        let request = NetworkHelper.createRequest(for: url, withMethod: HttpMethods.GET)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let decodedResponse = try? decoder.decode([FollowingUser].self, from: data) {
                for user in decodedResponse {
                    followingUsers.append(user)
                }
            }
            
            if let pagination = NetworkHelper.getPaginationLastPage(for: response) {
                await addPaginatedUsersIfAvailable(for: pagination)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        for user in followingUsers {
            modelContext.insert(user)
        }
    }
    
    func addPaginatedUsersIfAvailable(for pagination: Int) async {      
        print("Response of request uses pagination (pages: \(pagination))")
        for pageIndex in 2...pagination {
            let endpoint = "https://api.github.com/users/\(login)/following?page=\(pageIndex)"
            
            guard let url = URL(string: endpoint) else {
                print("Invalid url")
                return
            }
            
            let session = NetworkHelper.createUrlSession(sessionName: "Following User Session Paginated")
            let request = NetworkHelper.createRequest(for: url, withMethod: HttpMethods.GET)
            
            do {
                let (data, _) = try await session.data(for: request)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let decodedResponse = try? decoder.decode([FollowingUser].self, from: data) {
                    decodedResponse.forEach {
                        followingUsers.append($0)
                    }
                }
            } catch {
                print("Invalid data")
            }
        }
    }
    
}

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let methodCall = Logger(subsystem: subsystem, category: "PointsOfInterest")
    static let swiftData = Logger(subsystem: subsystem, category: "PointsOfInterest")
}

#Preview {
    FollowingUserView(login: "anschaefer")
}
