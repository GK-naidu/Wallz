import Foundation
import RiveRuntime

struct Constants {
    
    static let rvm =  RiveViewModel(fileName: "login_screen_character",stateMachineName: "State Machine 1")
    static let  lookIdle:  () = rvm.setInput("Look_idle", value: true)
    static let  handsUP:   () = rvm.setInput("hands_up", value: true)
    static let  handDown:  () = rvm.setInput("hands_up", value: false)
    static let  lookRight: () = rvm.setInput("Check", value: true)
    static let  lookLeft:  () = rvm.setInput("Look", value: 1.0)
    static let  Fail:      () = rvm.triggerInput("fail")
    static let  success:   () = rvm.triggerInput("success")
    
    
    //        VStack {
    //
    //            Constants.rvm.view()
    //                .onAppear{
    //                    Constants.lookIdle
    //
    //                }
    //            HStack {
    //
    //                Button {
    //                    Constants.handsUP
    //
    //                } label: {
    //                    Text("Hands up")
    //                        .padding()
    //                }
    //                Button {
    //                    Constants.handDown
    //
    //                } label: {
    //                    Text("Hands Down")
    //                        .padding()
    //                }
    //            }
    //            HStack {
    //                Button {
    //                    Constants.success
    //                } label: {
    //                    Text("Success")
    //                        .padding()
    //                }
    //                Button {
    //                    Constants.Fail
    //                } label: {
    //                    Text("fail")
    //                        .padding()
    //                }
    //
    //            }
    //            HStack {
    //                Button {
    ////                    rvm.setInput("Check", value: false)
    //                    Constants.lookLeft
    //                } label: {
    //                    Text("Look_down_left")
    //                        .padding()
    //                }
    //                Button {
    //
    //                    Constants.lookRight
    //                } label: {
    //                    Text("Look_down_right")
    //                        .padding()
    //                }
    //
    //            }
    //        }
    //            .padding()
    
}
