
import Foundation

// これはAPIから取得した写真データを整理して保存するためのものです。
struct Photo: Codable {
    // APIから取得した写真のURLを保存する辞書型のプロパティです。
    let urls: [String: String]
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
