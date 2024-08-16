//
//  SkeletonCellView.swift
//  wallzyi
//
//  Created by G.K.Naidu on 31/07/24.
//

import SwiftUI
import UIKit
import Combine





class UserSettings: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var hasSeenIntroScreens: Bool
    @Published var hasShownTrackingDialog: Bool
    @Published var hasCompletedIDFA: Bool

    init() {
        let isFirstLaunchFlag = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.isFirstLaunch = isFirstLaunchFlag
        self.hasSeenIntroScreens = UserDefaults.standard.bool(forKey: "hasSeenIntroScreens")
        self.hasShownTrackingDialog = UserDefaults.standard.bool(forKey: "hasShownTrackingDialog")
        self.hasCompletedIDFA = UserDefaults.standard.bool(forKey: "hasCompletedIDFA")

        if isFirstLaunchFlag {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }

    func markIntroScreensAsSeen() {
        DispatchQueue.main.async {
            self.hasSeenIntroScreens = true
            UserDefaults.standard.set(true, forKey: "hasSeenIntroScreens")
        }
    }

    func markTrackingDialogAsShown() {
        DispatchQueue.main.async {
            self.hasShownTrackingDialog = true
            UserDefaults.standard.set(true, forKey: "hasShownTrackingDialog")
        }
    }

    func completeIDFA() {
        DispatchQueue.main.async {
            self.hasCompletedIDFA = true
            UserDefaults.standard.set(true, forKey: "hasCompletedIDFA")
        }
    }
}







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


extension View {
    public func onScrollingChange(
        scrollingChangeThreshold: Double = 200.0,
        scrollingStopThreshold: TimeInterval = 0.5,
        onScrollingDown: @escaping () -> Void,
        onScrollingUp: @escaping () -> Void,
        onScrollingStopped: @escaping () -> Void) -> some View {
            self.modifier(OnScrollingChangeViewModifier(scrollingChangeThreshold: scrollingChangeThreshold, scrollingStopThreshold: scrollingStopThreshold, onScrollingDown: onScrollingDown, onScrollingUp: onScrollingUp, onScrollingStopped: onScrollingStopped))
        }
}


private struct OnScrollingChangeViewModifier: ViewModifier {
    let scrollingChangeThreshold: Double
    let scrollingStopThreshold: TimeInterval
    let onScrollingDown: () -> Void
    let onScrollingUp: () -> Void
    let onScrollingStopped: () -> Void
    
    @State private var scrollingStopTimer: Timer?
    @State private var offsetHolder = 0.0
    @State private var initialOffset: CGFloat?
    
    func body(content: Content) -> some View {
        content.background {
            GeometryReader { proxy in
                Color.clear
                    .onChange(of: proxy.frame(in: .global).minY, initial: true) { oldValue, newValue in
                        
                        // prevent triggering callback when boucing top edge to avoid jumpy animation
                        if initialOffset == nil {
                            initialOffset = oldValue
                        } else if newValue >= initialOffset! {
                            return
                        }
                        
                        let newValue = abs(newValue)
                        
                        if newValue > offsetHolder + scrollingChangeThreshold {
                            // We set thresh hold to current offset so we can remember on next iterations.
                            offsetHolder = newValue
                            
                            // is scrolling down
                            onScrollingDown()
                            
                        } else if newValue < offsetHolder - scrollingChangeThreshold {
                            
                            // Save current offset to threshold
                            offsetHolder = newValue
                            // is scrolling up
                            onScrollingUp()
                        }
                        
                        scrollingStopTimer?.invalidate()
                        scrollingStopTimer = Timer.scheduledTimer(withTimeInterval: scrollingStopThreshold, repeats: false, block: { _ in
                            onScrollingStopped()
                        })
                    }
            }
        }
    }
}






struct CustomTrackingDialog: View {
    @Binding var isActive: Bool
    let action: () -> ()
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack(spacing: 20) {
                Text("""
                     Allow tracking
                     on the next screen for :
                     """)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                
                VStack( spacing: 30) {
                    //                    HStack {
                    //                        Image(systemName: "heart.circle.fill")
                    //                            .font(.system(size: 30))
                    //                            .foregroundColor(.white)
                    //                        Text("Special offers and promotions just for you")
                    //                            .foregroundColor(.white)
                    //                            .font(.body)
                    //                    }
                    
                    HStack {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                        Text("Advertisements that match your interests")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding(.leading,5)
                    }
                    
//                    HStack {
//                        Image(systemName: "chart.bar.fill")
//                            .font(.system(size: 35))
//                            .foregroundColor(.white)
//                        Text("An improved personalized experience over time")
//                            .foregroundColor(.white)
//                            .font(.body)
//                            .padding(.leading,5)
//                    }
                }
                .padding(.vertical)
                
                Text("You can change this option later in the Settings app.")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    action()
                    close()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.yellow, Color.yellow.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom))
                            .frame(height: 60)
                        
                        Text("Continue")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.yellow.opacity(0.5), Color.black]),
                        startPoint: .topLeading,
                        endPoint: .bottom))
            )
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
        .background(
            AngularGradient(
                gradient: Gradient(colors: [Color.yellow, Color.black, Color.white]),
                center: .center
            )
            
            .cornerRadius(30)  // Added corner radius to match dialog style
                .ignoresSafeArea()
        )
        
        .shadow(radius: 30)  // Increased shadow radius
        .offset(y: offset)
       
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
        
   

    }

    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
    }
}

struct CustomTrackingDialog_Previews: PreviewProvider {
    static var previews: some View {
        CustomTrackingDialog(
            isActive: .constant(true),
            action: {}
        )
    }
}







