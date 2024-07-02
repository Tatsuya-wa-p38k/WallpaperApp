
import Foundation

struct UnsplachUser: Codable {
    let username: String
    let name:String
    let location: String?
}

struct UnsplachPhotoURLs:Codable {
    let regular: String
    let full: String
}
