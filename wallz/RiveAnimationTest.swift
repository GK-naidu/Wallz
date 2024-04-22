
import SwiftUI
import RiveRuntime

struct ReusableText: View {
    var text: String
    var font: Font
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(.white)
            .padding(.zero)
    }
}

struct UserNameView: View {
    @FocusState private var keyboardFocused: Bool
    @Binding var name : String
    
    
    
    var body: some View {
        TextField("Name", text: $name)
            .focused($keyboardFocused)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
            }
      
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(30.0)
            .frame(width: 350, height: 50)
            .padding(.bottom ,5)
            }
    }



struct RiveAnimationTest: View {
    
    @State private var NAME : String = ""
    let userDefaults = UserDefaults.standard
    
    @State private var isPresented : Bool = false
    
    
    var body: some View {
        
        VStack {
            Constants.rvm.view()
                .frame(width: 300,height: 300)
            VStack {
                
                ReusableText(text: "Hi There!",
                             font: .system(size: 16, weight: .semibold, design: .default))
                
                ReusableText(text: "Enter your name ",
                             font: .system(size: 24, weight: .bold, design: .default))
                
                UserNameView(name: $NAME).foregroundStyle(Color.blue)
                    .onSubmit {
                        userDefaults.set(NAME, forKey: "NAME")
                     print("Submitted")
                    }
                
            }.padding(EdgeInsets(top: 30, leading: 20, bottom: 40, trailing: 20))
                .cornerRadius(10)
                .background(Color.black.opacity(0.2))
                .cornerRadius(20)
            
            
            
            
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("Next")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.indigo))
            }).fullScreenCover(isPresented: $isPresented, content: {
                ContentView()
            })
            

            
            Spacer(minLength: 100)
            
            
            
        }.padding(40)
            .background(LinearGradient(colors: [Color("9D92DF"), Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .ignoresSafeArea(.keyboard)

    }

}

#Preview {
    RiveAnimationTest()
}
