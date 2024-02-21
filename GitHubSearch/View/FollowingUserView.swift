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
    @Query var followingUsers: [FollowingUser]
    
    var login: String
    
//    @State private var followingUsers = [FollowingUser]()
    
    var body: some View {
        NavigationStack {
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
            .onAppear().task {
                await getFollowingUsers(for: login)
            }
        }
    }
    
    func getFollowingUsers(for login: String) async {
        // Pagination needs to be variable
        for pageIndex in 1...20 {
            let endpoint = "https://api.github.com/users/\(login)/following?page=\(pageIndex)"
            
            guard let url = URL(string: endpoint) else {
                print("Invalid url")
                return
            }
            
            let requestHelper = NetworkHelper()
            let session = requestHelper.createUrlSession(sessionName: "Following User Session")
            let request = requestHelper.createRequest(for: url, withMethod: HttpMethods.GET)

            do {
                let (data, _) = try await session.data(for: request)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let decodedResponse = try? decoder.decode([FollowingUser].self, from: data) {
                    for user in decodedResponse {
                        let newUser = FollowingUser(login: user.login, avatarUrl: user.avatarUrl)
                        modelContext.insert(newUser)
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
