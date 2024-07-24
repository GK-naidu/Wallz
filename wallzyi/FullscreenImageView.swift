
import SwiftUI

struct FullscreenImageView: View {
    let imageURLs: [URL]
    @Binding var currentIndex: Int
    @Binding var isFullscreen: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    
                    AsyncImage(url: imageURLs[currentIndex]) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 700)
                    case .failure:
                        Text("Failed to load image")
                    @unknown default:
                        EmptyView()
                    }
                }
                
             
                    
                    Text("Downloaded image would be higher in resolution")
                        .foregroundColor(.white)
                        .frame(width: 370)
                        .padding()
                }
            }
        }
        .statusBar(hidden: true)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    withAnimation(.default) {
                        isFullscreen = false
                    }
                }
        )
    }
}

