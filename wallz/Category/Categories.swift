//
//  Categories.swift
//  wallz
//
//  Created by G.K.Naidu on 01/04/24.
//

import SwiftUI

public struct Categories: View {
    @State private var selectedCategory: String?
    @State private var showCategoryView = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let categoriesArray: [String] = [
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711861551/e2xspw2utpt67icc492m.png",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711794922/dtdyerpjg3mt4tadpulc.jpg",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711863136/memjx51ecucvmyb0vpsn.jpg",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711796955/jxlwthbdjbzurtwodwgo.jpg",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711796397/oql38hzibloopxbxydwt.png",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711794285/ayzyfpo9al45gcecqfd9.webp",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711797512/jmrthjk2chei2vdfxmpe.jpg",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711811158/fpywcutdfgvytmj0cyfe.png",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711861441/s2kh8s92kpzup7pmvjpi.jpg",
        "https://res.cloudinary.com/dq0rchxli/image/upload/v1711797649/totlpyjxzwrta4g47b1e.png"
    ]
    
    let overlayText : [String] = ["Anime","scenic","city","cars","amoled","Art","Batman","Marvel","Night","Games"]

    public var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("9D92DF"), Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(Array(categoriesArray.enumerated()), id: \.offset) { index, value in
                            Button(action: {
//                                selectedCategory = value
                                selectedCategory = overlayText[index]
                                showCategoryView = true
                            }) {
                                AsyncImage(url: URL(string: value)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 200, maxHeight: 200)
                                            .padding(.horizontal, 3)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay {
                                                ForEach(overlayText, id: \.self) { text in
                                                    if index < overlayText.count {
                                                        Text(overlayText[index])
                                                            .font(.largeTitle)
                                                            .foregroundStyle(Color.white)
                                                            .shadow(color: .white, radius: 0.5)
                                                    } else {
                                                        Text("Nil")
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .toolbar(.hidden)
            .sheet(isPresented: $showCategoryView) {
                     categoryView(selectedCategory: $selectedCategory)
                 }
        
        }
    }
}
