//
//  FavouriteView.swift
//  wallz
//
//  Created by G.K.Naidu on 25/02/24.
//

import SwiftUI

struct FavouriteView: View {
    
    @Binding var FavouriteList : [String]
    
    
    
    let columns = [
        GridItem(),
        GridItem()
    ]
   
    var body: some View {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                         
                        if FavouriteList != nil {
                            
                            ForEach(FavouriteList, id: \.self) { favourite in
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
                        }
                        
                    
                    .padding()
                }.onAppear{
                    print("\(FavouriteList .count)")
                }
 
    }
}







