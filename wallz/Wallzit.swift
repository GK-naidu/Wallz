import Foundation
import SwiftUI

struct ImageData: Identifiable, Decodable,Hashable {
    let id: String
    let name: String
    let url: String
    
//    let tags: [String]
    let categories: [String]
//    let Uniquecategories : [String]
//    let format: String
//    let created_at: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case url
//        case tags
        case categories
//        case Uniquecategories 
//        case format
//        case created_at
    }
}

struct CategoryData: Identifiable, Decodable,Hashable {
    let id: String
    let name: String
    let url: String
//    let tags: [String]
//    let categories: [String]
//    let format: String
//    let created_at: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case url
//        case tags
//        case categories
//        case format
//        case created_at
    }
}

//struct Favourite: Codable {
//
//    let url :  [String] = []
//    
//}

struct GitHubUser : Codable {
    let login : String
    
    let bio : String
    let avatarUrl : String
}

enum GHError : Error {
    case invalidURL
    case invalidData
    case invalidsomething
}
