//
//  UserView.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI
import MetricKit

struct UserView: View {
    var login: String
    @State private var user: GitHubUser?
    
    var body: some View {
            VStack {
                if let actualUser = user {
                    NavigationStack {
                        AsyncImage(url: URL(string: actualUser.avatarUrl)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 120, height: 120)
                        .padding()
                        
                        Text(actualUser.name)
                            .bold()
                            .font(.title3)
                        
                        Text(actualUser.bio)
                            .padding()

                        Text("Username: \(actualUser.twitterUsername)")
                        Text("Company: \(actualUser.company)")
                        Text("Followers: \(actualUser.followers)")
                        Text("Public Repos: \(actualUser.publicRepos)")
                        
                        NavigationLink("Following users (\(actualUser.following))", destination: FollowingUserView(login: actualUser.login))
                            .padding(.top, 20)
                            .buttonStyle(.bordered)
                            .disabled(actualUser.following == 0)
                            .navigationTitle("User View")
                            .toolbar(content: {
                                NavigationLink("Search", destination: ContentView())
                            })
                    }
                }
            }.task {
                await requestUser(with: login)
            }
    }
    
    func requestUser(with userHandle: String) async {
        
        do {
            try await getUser(by: userHandle)
        } catch GHError.invalidURL {
            print("invalid URL")
        } catch GHError.invalidData {
            print("invalid data")
        } catch GHError.invalidResponse {
            print("invalid response")
        } catch {
            print("unexpected error")
        }
    }
    
    func getUser(by handle: String) async throws{
        
        mxSignpost(.event, log: MXMetricManager.userViewHandle, name: "Get users from GitHub")
        
        let endpoint = "https://api.github.com/users/\(handle)"
        
        guard let url = URL(string: endpoint) else { throw GHError.invalidURL}
        
        let session = NetworkHelper.createUrlSession(sessionName: "Main Session")
        let request = NetworkHelper.createRequest(for: url, withMethod: HttpMethods.GET)
        
        let (data, response) = try await session.data(for: request)
 
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GHError.invalidResponse
            }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            user = try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}

extension MXMetricManager {
    static let userViewHandle = MXMetricManager.makeLogHandle(category: "UserView")
}

#Preview {
    UserView(login: "twostraws")
}
