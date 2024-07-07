import SwiftUI

struct TabBarTest: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            selectedTabView()
            
            VStack {
                Spacer()
                
                // Floating tab bar
                FloatingTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
    
    @ViewBuilder
    func selectedTabView() -> some View {
        switch selectedTab {
        case 0:
            categorygrid()
        case 1:
            GeometryReader { geometry in
                PopularView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        case 2:
            MyProfile()
        default:
            categorygrid()
        }
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarItem(imageName: "square.stack.3d.up.fill", title: "Categories", isSelected: selectedTab == 0)
                .onTapGesture { selectedTab = 0 }
            
            Spacer()
            
            TabBarItem(imageName: "flame.circle.fill", title: "Popular", isSelected: selectedTab == 1)
                .onTapGesture { selectedTab = 1 }
            
            Spacer()
            
            TabBarItem(imageName: "gearshape.fill", title: "Settings", isSelected: selectedTab == 2)
                .onTapGesture { selectedTab = 2 }
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
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarTest()
    }
}
