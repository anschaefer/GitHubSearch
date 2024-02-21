//
//  DetailsView.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI

struct DetailsView: View {
    let user: GitHubUser
     
    var body: some View {
        VStack(spacing: 20) {
            NavigationStack {
                Text("Username: \(user.twitterUsername)")
                Text("Company: \(user.company)")
                Text("Followers: \(user.followers)")
                Text("Public Repos: \(user.publicRepos)")
                
                NavigationLink("Request following users (\(user.following))", destination: FollowingUserView(login: user.login))
                    .padding(.top, 20)
                    .buttonStyle(.bordered)
                    .disabled(user.following == 0)
                    .navigationTitle("Detail View")
            }
        }
    }
}

#Preview {
    DetailsView(user: GitHubUser(login: "johnDough", avatarUrl: "", bio: "Fake bio", twitterUsername: "johnDough", name: "John Doe", followers: 0, following: 0, publicRepos: 0, company: ""))
}
