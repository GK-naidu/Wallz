import SwiftUI

struct BackgroundColour: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    let colourCollection : [Color] = [.red,.blue,.green,.purple,.pink,.teal,.cyan,.brown,.indigo,.yellow]
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://res.cloudinary.com/dq0rchxli/image/upload/v1714466490/cnnr7x8ctgyyqbthw8en.png")){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .blur(radius: 2.0)
                } else {
                    
                // show something when the  background doesn't load , like a colour or something
                    colourCollection
                        .randomElement()
                         .opacity(0.7)
                         .ignoresSafeArea()
                }
            }
            
            
            
            
        }
    }
}



