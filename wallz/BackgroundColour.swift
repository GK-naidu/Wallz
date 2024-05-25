import SwiftUI

struct BackgroundColour: View {
    
    @ObservedObject var sharedData = SharedData.shared
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
            
            
            VStack {
          
                ColorPicker("Colour ->", selection: $sharedData.backgroundColor)
                    
                    .fontWeight(.bold)
                    .frame(width: 150,height: 50)
                    .background{
                        RoundedRectangle(cornerRadius: 20).opacity(0.3)
                            .frame(width: 200,height: 75)
                    }
                    .padding()
       
                
                Button {

                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .overlay {
                            Text("Save")
                                .foregroundStyle(Color.blue)
                        }
                        
                        .frame(width: 100,height: 45)
                        .padding()
                    
                }
                
            }
            
        }
    }
}



