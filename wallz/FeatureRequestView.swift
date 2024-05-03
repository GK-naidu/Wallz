import SwiftUI

struct FeatureRequestView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
        
                Section {
                    TextField("", text: $title)
                } header: {
                    Text("title")
                }

                Section {
                    TextField("", text: $description,axis: .vertical)
                        .lineLimit(5)
                       
                                   
                } header: {
                    Text("Descripiton")
                }

                
                    TextField("Email (Optional)", text: $email)
                
                
                Section {
                    Button(action: sendRequest) {
                        HStack {
                            Spacer()
                            Text("Send Request")
                            Spacer()
                        }
                            
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
            .navigationBarTitle("Feature Request", displayMode: .inline)
        }
    }
    
    func sendRequest() {
        let requestBody = "Title: \(title)\nDescription: \(description)\nEmail: \(email)"
        
        if let emailURL = URL(string: "mailto:kanekilighteren@gmail.com?subject=Feature%20Request&body=\(requestBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") {
            UIApplication.shared.open(emailURL)
        }
    }
}

#Preview {
    FeatureRequestView()
}
