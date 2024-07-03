
import Foundation

// これはAPIから取得した写真データを整理して保存するためのものです。
struct Photo: Codable {
    let id: String
    let urls: [String: String]
    let user: User
}

struct User: Codable {
    let name: String
    let location: String? // locationプロパティを追加
    let updated_at: String
}

struct PhotoResults: Codable {
    let results: [Photo]
}

struct TagSearchParameters:Codable {
    let query: String
    let color: String
    let perPage: Int
}

struct UnsplachUser: Codable {
    let username: String
    let name:String
    let location: String?
}

struct UnsplachPhotoURLs:Codable {
    let regular: String
    let full: String
}
