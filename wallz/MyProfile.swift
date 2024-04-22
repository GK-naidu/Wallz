//
//  MyProfile.swift
//  wallz
//
//  Created by G.K.Naidu on 25/02/24.


import SwiftUI

import SwiftUI

struct profileModifer : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundStyle(Color.primary)
            .frame(maxWidth: 350,maxHeight: 70)
            .background(RoundedRectangle(cornerRadius: 20))
            
            .padding()
    }
    
    
}

struct MyProfile: View {
    

    var body: some View {
//        ZStack {
         
            VStack {
                
                    AsyncImage(url: URL(string: "https://xsgames.co/randomusers/assets/avatars/pixel/36.jpg")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding()
                        }
                        else {
                            ProgressView()
                        }
                    }
                    
                    Text(" Hi, profile name")
                    .font(.title)
                    .foregroundStyle(Color.primary)
    
                Link("Privacy policy", destination: URL(string: "https://www.privacypolicy.com/")!)
                    .foregroundStyle(Color.green)
                    .modifier(profileModifer())
    
                Button(action: {
                    
                }) {
                    Text("Rate our app")
                        .foregroundStyle(Color.purple)
                        .modifier(profileModifer())
                       
                    
                }
                
                Button(action: {
                    
                }) {
                    Text("background colour")
                        .foregroundStyle(Color.yellow)
                        .modifier(profileModifer())
                    
                }
                
                Button(action: {
                    
                }) {
                    Text("Feature Request")
                        .foregroundStyle(Color.blue)
                        .modifier(profileModifer())
                    
                }
                
                
                
                Spacer()
            }
        
//        }
    }

    
}

#Preview {
    MyProfile()
}








