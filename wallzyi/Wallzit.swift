import Foundation
import SwiftUI

struct ImageData: Identifiable, Decodable, Hashable {
    let id: String
//    let name: String
    var url: String?
    let highQualityUrl : String?
    let lowQualityUrl : String?
    
 
    
    
//    let categories: [String]
//    let size: Size
//    let tags: [String]?
//    let format: String
//    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case  url,lowQualityUrl , highQualityUrl
        
//        case name,size,tags,format,createdAt
//        case createdAt = "created_at"
    }
    
    
    
    
    
}

let sampleData: [ImageData] = [
    ImageData(id: "669bc499286a8e2ed4518e52",
              highQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484436/okdxnkpyv9tna1s8ae0v.jpg",
              lowQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484440/owyje9ztwqrlglmhdfx9.jpg"),
    
    ImageData(id: "669bc4ad286a8e2ed4518e54",
              highQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484457/dbpytsfh7mb866r0nx7h.jpg",
              lowQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484460/y8ksu9rjjdsjpasdtxvi.jpg"),
    
    ImageData(id: "669bc4c6286a8e2ed4518e56",
              highQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484482/xiuuovwd6x5largioahw.jpg",
              lowQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484485/jki0nlprvdrlo0mqofad.jpg")
]

struct Size: Codable, Hashable {
    let width: Int
    let height: Int
}

struct CategoryData: Identifiable, Decodable, Hashable {
    let id: String
//    let name: String
//    let url: String?
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
        case  lowQualityUrl , highQualityUrl
    }
}
