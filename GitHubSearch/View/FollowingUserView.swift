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
            Button("Get Following Users") {
                Task {
                    await getFollowingUsers(for: login)
                }
            }
            
            List(followingUsers, id: \.login) { item in
                HStack() {
                    AsyncImage(url: URL(string: item.avatarUrl)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 40, height: 40)
                    
                    NavigationLink(item.login, destination: UserView(login: item.login))
                        .font(.headline)
                        .navigationTitle("Following Users")
                    
                }
            }
            .toolbar(content: {
                NavigationLink("Search", destination: ContentView())
            })
        }
    }
    
    
    
    func getFollowingUsers(for login: String) async {
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
            print("Invalid data")
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
    
    // category is important for showing it in instruments...otherwise it can be customized
    static let methodCall = Logger(subsystem: subsystem, category: "PointsOfInterest")
    static let swiftData = Logger(subsystem: subsystem, category: "PointsOfInterest")
}

#Preview {
    FollowingUserView(login: "anschaefer")
}
