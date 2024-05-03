//
//  CustomTabBar.swift
//  wallz
//
//  Created by G.K.Naidu on 24/04/24.
//

import SwiftUI

struct CustomTabBar: View {
    @State var tabPoints : [CGFloat] = []
    
    @Binding var selectedTab : String 
    var body: some View {
        HStack (spacing: 0) {
            //MARK: -  tab bar buttons
            TabBarButtons(image: "square.stack.3d.up", selectedTab: $selectedTab, tabPoints: $tabPoints)
            
            TabBarButtons(image: "flame.circle", selectedTab: $selectedTab, tabPoints: $tabPoints)
            
            TabBarButtons(image: "hand.thumbsup", selectedTab: $selectedTab, tabPoints: $tabPoints)
            
            TabBarButtons(image: "person", selectedTab: $selectedTab, tabPoints: $tabPoints)
                
        }
        .frame(height: 50)
        .padding()
        .background(
            Color.white
                .clipShape(TabCurve(tabPoint: getCurvePoint() - 15))
        )
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal)
    }
    func getCurvePoint()->CGFloat {
        if tabPoints.isEmpty {
            return 10
        }
        else {
            switch selectedTab {
                        case "square.stack.3d.up":
                            return tabPoints[0]
                        case "flame.circle":
                            return tabPoints[1]
                        case "hand.thumbsup":
                            return tabPoints[2]
                        case "person":
                            return tabPoints[3]
                        default:
                            return tabPoints[3]
                        }
        }
    }
}




//#Preview {
//    Home()
//}

struct TabBarButtons : View {
    var image : String
    @Binding var selectedTab : String
    @Binding var tabPoints : [CGFloat]
    
    var body: some View {
        //for getting mid Point of each button to make curve animation
        GeometryReader{ reader -> AnyView in
            
            let midX = reader.frame(in: .global).midX
            DispatchQueue.main.async{
                if tabPoints.count <= 4 {
                    tabPoints.append(midX)
                }
            }

           return AnyView(
            Button(action: {
                //changing Tab...
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5)) {
                    selectedTab = image
                }
                
                
            }, label: {
                //filling the colour if it's selected
                
                
                Image(systemName: "\(image)\(selectedTab == image ?".fill":"")")
                    .font(.system(size: 25,weight: .semibold))
                    .foregroundStyle(Color.tabSelected)
                //lifting View
                //if it's selected
                    .offset(y:selectedTab == image ? -10 : 0)
            })
            //maxframe
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            
            //maxHeight
            .frame( height: 50))
        }
    }
}



