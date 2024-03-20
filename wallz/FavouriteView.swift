//
//  FavouriteView.swift
//  wallz
//
//  Created by G.K.Naidu on 25/02/24.
//

import SwiftUI

struct FavouriteView: View {
    
    @State var favwalls = ContentView().favoritesWallpaper
    
    
    
    let columns = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                
                if favwalls.isEmpty == false {
                    
                    ForEach(favwalls, id: \.self) { favourite in
                        AsyncImage(url: URL(string: favourite)) { phase in
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
                        .padding()
                    }
                    
                }
                
                else {
                    Spacer()
                    Text ( "Nothing liked yet")
                        .font(.largeTitle)
                    Spacer()
                }
            }
            
            .padding()
        }.onAppear{
            print("Favrt \(favwalls.count)")
        }
        
    }
}



#Preview {
    FavouriteView(favwalls: ["#Preview"])
}
