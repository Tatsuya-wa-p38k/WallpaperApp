
import Foundation

struct Photo: Codable {
    let id: String
    let urls: [String: String]
    let user: User
    let updatedAt: String
    let alternativeSlugs: [String: String]
}

struct User: Codable {
    let name: String
    let username: String
    let location: String?
}

struct PhotoResults: Codable {
    let results: [Photo]
}

struct TagSearchParameters:Codable {
    let query: String
    let color: String
    let perPage: Int
}

//struct UnsplachUser: Codable {
//    let username: String
//    let name:String
//    let location: String?
//}
