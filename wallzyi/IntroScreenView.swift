import SwiftUI

struct IntroScreenView: View {
    let title: String
    let description: String
    let imageName: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 200)
                .foregroundColor(.yellow)
                
            
            VStack {
                
                
                Spacer()
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    
                    .padding()
                
             
            }
            .frame(width: 300)
        }
        
        
       
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
    }
}






struct IntroScreensView: View {
    @Binding var showIntroScreens: Bool
    @State private var currentPage = 0
    private let pages = [
        IntroScreenView(
            title: 
                """
                   welcome to
                        wallzyi
                   """,
            description: "Discover beautiful wallpapers.",
            imageName: "welcome"
        ),
        IntroScreenView(
            title: " 2000+ wallpapers",
            
            
            description: "Browse through Ai Generated collections.",
            imageName: "2000+"
        ),
        IntroScreenView(
            title: "Explore",
            description: "Personalize your wallpaper settings for a unique look.",
            imageName: "Explore"
        )
    ]

    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
        VStack {
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    pages[index]
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                if currentPage < pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .frame(width: 200)
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        
                    }
                } else {
                    Button(action: {
                        showIntroScreens = false
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
    
    }
}



struct IntroScreens: PreviewProvider {
    @State private var showintro = false
    static var previews: some View {
        IntroScreensView(showIntroScreens: .constant(true))
        
    }
}
