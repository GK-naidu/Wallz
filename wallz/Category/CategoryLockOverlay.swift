//
//  CategoryLockOverlay.swift
//  wallz
//
//  Created by G.K.Naidu on 24/04/24.
//

import SwiftUI

struct CategoryLockOverlay: View {
    @State var categorydata : CategoryData?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
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
                    Text("Lock screen preivew is under maintenance")
                    
                }
            }
            
            Image("LockOverlay")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .shadow(radius: 2)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }


        }
    }
}

#Preview {
    CategoryLockOverlay()
}
