import Foundation
import SwiftUI

struct ImageData: Identifiable, Decodable,Hashable {
    let id: String
    let name: String
    let url: String
    let tags: [String]
    let categories: [String]
    let format: String
    let created_at: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case url
        case tags
        case categories
        case format
        case created_at
    }
}

struct Favourite: Identifiable,Hashable {
    let id = UUID()
    let url: String
    
}
