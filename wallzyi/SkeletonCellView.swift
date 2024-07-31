//
//  SkeletonCellView.swift
//  wallzyi
//
//  Created by G.K.Naidu on 31/07/24.
//

import SwiftUI

// BlinkViewModifier
struct BlinkViewModifier: ViewModifier {
    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.3 : 1)
            .animation(.easeInOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                blinking.toggle()
            }
    }
}

extension View {
    func blinking(duration: Double = 1) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}

// SkeletonCellView
// SkeletonCellView
struct SkeletonCellView: View {
    let primaryColor = Color(.init(gray: 0.9, alpha: 1.0))
    let secondaryColor  = Color(.init(gray: 0.8, alpha: 1.0))
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Rectangle()
                .fill(secondaryColor)
                .frame(width: 150, height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
        
        }
    }
}

// SkeletonView
struct SkeletonView: View {
    var body: some View {
        VStack(spacing: 50) {
            SkeletonCellView()
   
        }
        .blinking(duration: 0.75)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}
