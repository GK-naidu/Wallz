import SwiftUI

struct FeatureRequestView: View {
    @State private var description = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("", text: $description, axis: .vertical)
                        .lineLimit(5)
                } header: {
                    Text("Feedback")
                }
                
                
                
                Section {
                    Button(action: sendRequest) {
                        HStack {
                            Spacer()
                            Text("Send Request")
                            Spacer()
                        }
                    }
                    .disabled(description.count < 4)
                }
            }
            .navigationBarTitle("Feedback", displayMode: .inline)
        }
    }
    
    func sendRequest() {
        let requestBody = "Description: \(description)\nEmail: \(email)"
        
        if let emailURL = URL(string: "mailto:swiftandme@gmail.com?subject=Feedback&body=\(requestBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") {
            UIApplication.shared.open(emailURL)
        }
    }
}

#Preview {
    FeatureRequestView()
}
