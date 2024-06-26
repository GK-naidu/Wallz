//
//  PopularView.swift
//  wallz
//
//  Created by G.K.Naidu on 28/05/24.
//

import SwiftUI
import Nuke

struct PopularView: View {
    @State private var data: [ImageData] = []
    @State private var selectedImage: ImageData?
    @State var showSplash: Bool = false
    @State private var page: Int = 1
    
    private let limit = 10
    private var offset = 0
    @State private var isLoadingMore: Bool = false
    let coloursRandom : [Color] = [.white,.blue,.green,.pink]
    @State private var BGColour : Color = .yellow
    @ObservedObject var sharedData = SharedData.shared
    let columns = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        
        ZStack {

            Image("quotes")
                .resizable()
                .scaledToFill()
                .blur(radius: 4)
                .ignoresSafeArea()
                
                
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(data) { item in
                        NavigationLink(value: item) {
                            AsyncImage(url: URL(string: item.url)!) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 350)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                } else {
                                    ProgressView()
                                        .frame(width: 150, height: 350)
                                        .background(Color.gray)
                                        .cornerRadius(20)
                                }
                            }
                            .shadow(radius: 9)
                            .padding()
                        }
                        .task {
                            if item == data.last {
                                loadMoreImages()
                                print("Last element")
                            }
                        }
                        .onTapGesture {
                            selectedImage = item
                        }
                    }
                   
                }
                .padding()
                .onAppear {
                    loadData(page: page)
                    print(data.count)
                }
                
            }
           
        }
        .toolbar(.hidden)
        .navigationDestination(for: ImageData.self) { image in
            WallScreen(imageData: image)
        }
    
   
}
    
    func loadMoreImages() {
        page += 1
        loadData(page: page)
    }
    
    func loadData(page: Int) {
        
    }
}

#Preview {
    PopularView()
}
