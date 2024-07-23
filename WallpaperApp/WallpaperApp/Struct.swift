
import Foundation

// Photo構造体を定義。写真データを表現するための構造体
struct Photo: Codable {
    let id: String// 写真のユニークな識別子
    let urls: [String: String] // 写真のURLを格納する辞書。キーは用途（例：'raw', 'full', 'regular'など）を表し、値は実際のURLとなる
    let user: User // 写真のアップロードユーザー情報。User構造体型で定義
    let updatedAt: String// 写真が最後に更新された日時を表す文字列
    let alternativeSlugs: [String: String]//代替スラッグ（URL用の文字列）を格納する辞書
}

// User構造体を定義。写真をアップロードしたユーザーの情報を表現
struct User: Codable {
    let name: String// ユーザーの名前
    let username: String// ユーザーのユーザーネーム
    let location: String? // ユーザーの位置情報。オプショナル型なのは位置情報がない場合を考慮
}

// PhotoResults構造体を定義。写真検索結果を表現するための構造体
struct PhotoResults: Codable {
    // 検索結果の写真配列。Photo構造体の配列として定義
    let results: [Photo]
}

// TagSearchParameters構造体を定義。写真検索時のパラメータを表現
struct TagSearchParameters:Codable {
    let query: String // 検索クエリ（検索キーワード）
    let color: String // 検索する写真の色
    let perPage: Int // 1ページあたりの結果数(画像の表示数)
}
