//
//  FollowingUserView.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI
import SwiftData

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
        let endpoint = "https://api.github.com/users/\(login)/following"
        
        
        guard let url = URL(string: endpoint) else {
            print("Invalid url")
            return
        }
        
        let requestHelper = NetworkHelper()
        let session = requestHelper.createUrlSession(sessionName: "Following User Session")
        let request = requestHelper.createRequest(for: url, withMethod: HttpMethods.GET)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let decodedResponse = try? decoder.decode([FollowingUser].self, from: data) {
                for user in decodedResponse {
                    followingUsers.append(user)
                }
            }
            
            if let pagination = requestHelper.getPaginationLastPage(for: response) {
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
        let requestHelper = NetworkHelper()
        
        print("Response of request uses pagination (pages: \(pagination))")
        for pageIndex in 2...pagination {
            let endpoint = "https://api.github.com/users/\(login)/following?page=\(pageIndex)"
            
            guard let url = URL(string: endpoint) else {
                print("Invalid url")
                return
            }
            
            let session = requestHelper.createUrlSession(sessionName: "Following User Session Paginated")
            let request = requestHelper.createRequest(for: url, withMethod: HttpMethods.GET)
            
            do {
                let (data, _) = try await session.data(for: request)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let decodedResponse = try? decoder.decode([FollowingUser].self, from: data) {
                    for user in decodedResponse {
                        followingUsers.append(user)
                    }
                }
            } catch {
                print("Invalid data")
            }
        }
    }
    
}

#Preview {
    FollowingUserView(login: "anschaefer")
}
