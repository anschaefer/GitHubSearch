//
//  SearchView.swift
//  GitHubSearch
//
//  Created by André Schäfer on 21.02.24.
//

import SwiftUI

struct SearchView: View {
    @State private var login = ""
    
    var body: some View {
        VStack {
            NavigationStack {
                Text("GitHub Profiles")
                    .font(.headline)
                    .padding()
                
                TextField("GitHub login", text: $login)
                    .textFieldStyle(.roundedBorder)
                    .padding([.trailing, .leading], 40)
                
                NavigationLink(destination: {
                    UserView(login: login)
                }, label: {
                    Text("Search")
                })
                .buttonStyle(.borderedProminent)
                .padding(.top, 20)
                .disabled(login == "")
            }
        }
    }
}

#Preview {
    SearchView()
}
