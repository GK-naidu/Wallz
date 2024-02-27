//
//  FavouriteView.swift
//  wallz
//
//  Created by G.K.Naidu on 25/02/24.
//

import SwiftUI

struct FavouriteView: View {
    
    @Binding  var Favouritte: [Favourite]
    
    
    let columns = [
        GridItem(),
        GridItem()
    ]
   
    var body: some View {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Favouritte) { favorite in
                            AsyncImage(url: URL(string: favorite.url)) { phase in
                                if let image = phase.image {
        
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 350)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
        
                                    Text("\(favorite.url)")
        
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
                    .padding()
                }.onAppear{
        
                    print("\(Favouritte.count)")
                }
 
    }
}




