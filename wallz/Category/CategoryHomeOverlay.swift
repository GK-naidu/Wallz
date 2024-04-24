//
//  CategoryHomeOverlay.swift
//  wallz
//
//  Created by G.K.Naidu on 24/04/24.
//

import SwiftUI

struct CategoryHomeOverlay: View {
    @State var categorydata : CategoryData?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
      
        ZStack {
            AsyncImage(url: URL(string: categorydata?.url ?? "" )) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        
                        

                } else {
//                    ProgressView()
//                        .frame(width: 250, height: 500)
//                        .padding()
                    Text("Home screen preivew is under maintenance")
                    
                }
            }
            
            Image("HomeOverlay")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding()
                .shadow(radius: 0.5)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }


        }
    }
}

#Preview {
    CategoryHomeOverlay()
}
