import SwiftUI

struct FullscreenImageView: View {
    let imageURLs: [URL]
    @Binding var currentIndex: Int
    @Binding var isFullscreen: Bool
    @State private var offset: CGFloat = 0
    @State private var dragging = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ImagePagerView(
                    imageURLs: imageURLs,
                    currentIndex: $currentIndex,
                    pageWidth: geometry.size.width,
                    pageHeight: geometry.size.height
                )
                .offset(y: offset)
                .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragging = true
                            offset = value.translation.height
                        }
                        .onEnded { value in
                            dragging = false
                            let threshold = geometry.size.height * 0.2
                            withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                                if abs(offset) > threshold {
                                    if offset > 0 {
                                        currentIndex = (currentIndex - 1 + imageURLs.count) % imageURLs.count
                                    } else {
                                        currentIndex = (currentIndex + 1) % imageURLs.count
                                    }
                                }
                                offset = 0
                            }
                        }
                )
            }
        }
        .statusBar(hidden: true)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isFullscreen = false
                    }
                }
        )
    }
}

struct ImagePagerView: View {
    let imageURLs: [URL]
    @Binding var currentIndex: Int
    let pageWidth: CGFloat
    let pageHeight: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<imageURLs.count, id: \.self) { index in
                AsyncImage(url: imageURLs[index]) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: pageWidth, height: pageHeight)
                    } else {
                        ProgressView()
                            .frame(width: pageWidth, height: pageHeight)
                    }
                }
            }
        }
        .frame(width: pageWidth, height: pageHeight, alignment: .leading)
        .offset(x: -CGFloat(currentIndex) * pageWidth)
        .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: currentIndex)
    }
}
