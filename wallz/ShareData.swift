import SwiftUI
import Combine

final class SharedData: ObservableObject {
    @Published var backgroundColor: Color = .white

    static let shared = SharedData()

    private init() {}
}
