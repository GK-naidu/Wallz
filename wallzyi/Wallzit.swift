import Foundation
import SwiftUI

struct ImageData: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    var url: String?
    let highQualityUrl : String?
    let lowQualityUrl : String?
    
    
    let categories: [String]
    let size: Size
    let tags: [String]?
    let format: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, url, categories, size, tags, format ,lowQualityUrl , highQualityUrl
        case createdAt = "created_at"
    }
    
    
    
    
    
}

struct Size: Codable, Hashable {
    let width: Int
    let height: Int
}

struct CategoryData: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let url: String?
    let highQualityUrl : String?
    let lowQualityUrl : String?
    
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }

     static func == (lhs: CategoryData, rhs: CategoryData) -> Bool {
         return lhs.id == rhs.id
     }
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, url , lowQualityUrl , highQualityUrl
    }
}
