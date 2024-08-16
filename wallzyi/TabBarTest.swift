import SwiftUI


struct TabBarTest: View {
    @State private var selectedTab = 1
    @State private var isTabBarHidden = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            selectedTabView()
            
            if !isTabBarHidden {
                VStack {
                    Spacer()
                    
                    // Floating tab bar with folding animation
                    FloatingTabBar(selectedTab: $selectedTab)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .scaleEffect(isTabBarHidden ? 0.7 : 1)
                        .opacity(isTabBarHidden ? 0 : 1)
                        .offset(y: isTabBarHidden ? 100 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isTabBarHidden)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    @ViewBuilder
    func selectedTabView() -> some View {
        switch selectedTab {
        case 0:
            CategoryGridView()
            
        case 1:
            GeometryReader { geometry in
                PopularView(isTabBarHidden: $isTabBarHidden)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            
        case 2:
            MyProfile()
            
        default:
            CategoryGridView()
        }
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarItem(imageName: "square.stack.3d.up.fill", title: "Categories", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            Spacer()
            
            TabBarItem(imageName: "flame.circle.fill", title: "Popular", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            Spacer()
            
            TabBarItem(imageName: "gearshape.fill", title: "Settings", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.yellow)
        )
        .animation(.easeInOut, value: selectedTab)
    }
}

struct TabBarItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .foregroundColor(isSelected ? .black : .gray)
                .font(.system(size: 24))
            
            Text(title)
                .foregroundColor(isSelected ? .black : .gray)
                .font(.caption)
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onTapGesture {
            action()
            performHapticFeedback()
        }
    }
    
    private func performHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarTest()
    }
}
