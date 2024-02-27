//
//  MyProfile.swift
//  wallz
//
//  Created by G.K.Naidu on 25/02/24.
//

import SwiftUI

struct MyProfile: View {
    @State private var user : GitHubUser?
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.4)
                .blur(radius: 13)
                .ignoresSafeArea()
            VStack {
                Spacer()
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    
                }placeholder: {
                    Circle()
                        .foregroundStyle(.secondary)
                    
                        .padding()
                }.frame(width: 150,height: 150)
                
                
                
                
                Text(user?.login ?? "Nil name")
                    .fontWeight(.heavy)
                
                    .padding(.vertical)
                
                Text(user?.bio ?? "Nil Bio")
                    .fontWeight(.medium)
                    .padding(.vertical)
                
                
                Spacer()
                
            }.task {
                do {
                    user = try await getUser()
                }catch  {
                    print("Invalid URL dude, check at Myprofile task")
                }
            }
            
        }
    }
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/GK-naidu"
        guard let url = URL(string:endpoint ) else {throw GHError.invalidURL }
        let(data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,response.statusCode == 200 else {
            throw GHError.invalidData
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        }
        catch {
            throw GHError.invalidsomething
        }
    }
}

#Preview {
    MyProfile()
}
