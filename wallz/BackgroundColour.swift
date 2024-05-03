import SwiftUI

struct BackgroundColour: View {
//    @EnvironmentObject var settings: UserSettings
    @ObservedObject var sharedData = SharedData.shared
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://res.cloudinary.com/dq0rchxli/image/upload/v1714466490/cnnr7x8ctgyyqbthw8en.png")){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .blur(radius: 5.0)
                } else {
                    
//                    Color.cyan
  
                }
            }
            
            
            VStack {
                
               Text("Selected Colour :")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(sharedData.backgroundColor)
                    .frame(width: 350,height: 100)
                    .padding()
                
                
                
                ColorPicker("Colour ->", selection: $sharedData.backgroundColor)
                    .frame(width: 150,height: 50)
                    .background{
                        RoundedRectangle(cornerRadius: 20).opacity(0.3)
                            .frame(width: 200,height: 75)
                    }
                    .padding()
                    
                     
                    
                
                
                Button {
//                    settings.saveBackgroundColor()
                    
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





final class UserSettings: ObservableObject {
    
    init(initialColor: Color) {
        self.backgroundColor = initialColor
        if let hexValue = UserDefaults.standard.string(forKey: "backgroundColor"),
           let color = Color(hex: hexValue) {
            self.backgroundColor = color
             
        }
    }
    
    @Published var backgroundColor: Color = .white {
        didSet {
            // Remove the didSet code that saves the color
        }
    }
    
    init() {
        if let hexValue = UserDefaults.standard.string(forKey: "backgroundColor"),
           let color = Color(hex: hexValue) {
            self.backgroundColor = color
            
        }
    }
    
    func saveBackgroundColor() {
        if let hexValue = backgroundColor.toHex() {
            UserDefaults.standard.set(hexValue, forKey: "backgroundColor")
            objectWillChange.send()
            updateBackgroundColor()
        }
    }
    
    
    func updateBackgroundColor() {
      // Notify all observing views about the color change
      objectWillChange.send()
    }
    
}


extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        guard let components = uiColor.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b)
    }
}


//
//#Preview {
//    BackgroundColour()
//}
