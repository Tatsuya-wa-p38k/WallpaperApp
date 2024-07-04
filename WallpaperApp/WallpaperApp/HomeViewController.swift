import UIKit

// Unsplash APIにアクセスするためのキーを定義します。
// これはAPIを使うためのパスワードのようなものです。
private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

// UnsplashAPIという名前のクラスを定義します。
// このクラスには、Unsplash APIから写真を取得する機能があります。
class UnsplashAPI {
    //このメソッドは非同期でAPIから写真を取得し、取得した写真をcompletionハンドラで返します。
    static func fetchPhotos(completion: @escaping ([Photo]?) -> Void) {
        // APIのURLを文字列として定義します。
        let urlString = "https://api.unsplash.com/photos/?per_page=5&order_by=latest&client_id=\(accessKey)"
        // URLオブジェクトを生成します。
        // 文字列が正しいURLでない場合、nilを返して終了します。
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // URLセッションを使用して、指定したURLからデータを非同期で取得します。
        URLSession.shared.dataTask(with: url) { data, response, error in
            // データが取得でき、エラーがないか確認します。
            guard let data = data, error == nil else {
                print("データの取得に失敗しました: \(error?.localizedDescription ?? "エラーなし")")
                completion(nil)
                return
            }
            do {
                // 取得したデータをPhoto構造体の配列に変換します。
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photos = try decoder.decode([Photo].self, from: data)
                completion(photos)
            } catch {
                // デコードに失敗した場合、エラーメッセージを表示してnilを返します。
                print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()// タスクを開始します。
    }
    
    class UnsplashAPI {
        static func searchPhotos(query: String, completion: @escaping ([Photo]?) -> Void) {
            let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=\(accessKey)"
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("データの取得に失敗しました: \(error?.localizedDescription ?? "エラーなし")")
                    completion(nil)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    completion(searchResults.results)
                } catch {
                    print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }
    }

    struct SearchResults: Codable {
        let total: Int
        let totalPages: Int
        let results: [Photo]
    }

    
    static func searchPhotos(query: String, completion: @escaping ([Photo]?) -> Void) {
           let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=\(accessKey)"
           guard let url = URL(string: urlString) else {
               completion(nil)
               return
           }

           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   print("データの取得に失敗しました: \(error?.localizedDescription ?? "エラーなし")")
                   completion(nil)
                   return
               }
               do {
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                   let searchResults = try decoder.decode(SearchResults.self, from: data)
                   completion(searchResults.results)
               } catch {
                   print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                   completion(nil)
               }
           }.resume()
       }
}


// HomeViewControllerという名前のクラスを定義します。
// このクラスはUIViewControllerを継承し、コレクションビューに写真を表示します。
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // コレクションビューをIBOutletとして接続します。
    @IBOutlet weak var wallpaperCollectionView: UICollectionView!
    // 写真の配列を保持するためのプロパティです。
    private var photos: [Photo] = []

    // ビューがロードされたときに呼ばれるメソッドです。
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search photos"
        self.navigationItem.titleView = searchBar

        // SectionHeaderを登録します。
        wallpaperCollectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"SectionHeader")

        // コレクションビューのレイアウトを設定します。
        // 画像間のスペースを0に設定します。
        if let flowLayout = wallpaperCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }

        // UnsplashAPIから写真を取得します。
        UnsplashAPI.fetchPhotos { [weak self] photos in
            // 取得した写真をプロパティに保存し、コレクションビューをリロードします。
            guard let self = self, let photos = photos else { return }
            self.photos = photos
            DispatchQueue.main.async {
                self.wallpaperCollectionView.reloadData()
            }
        }

        wallpaperCollectionView.delegate = self
        wallpaperCollectionView.dataSource = self

    }
    
    // UISearchBarDelegate method
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         guard let query = searchBar.text, !query.isEmpty else { return }
         searchPhotos(query: query)
     }
    
    private func searchPhotos(query: String) {
         UnsplashAPI.searchPhotos(query: query) { [weak self] photos in
             guard let self = self, let photos = photos else { return }
             self.photos = photos
             DispatchQueue.main.async {
                 self.wallpaperCollectionView.reloadData()
                 self.showSearchResults(query: query)
             }
         }
     }
    
    private func showSearchResults(query: String) {
        let urlString = "https://unsplash.com/s/photos/\(query)"
        let resultVC = ResultSearchViewController()
        resultVC.urlString = urlString
        let navController = UINavigationController(rootViewController: resultVC)
        self.present(navController, animated: true, completion: nil)
    }

    // セクション内のアイテム数を返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    // アイテムを返すメソッドです。
    // セルを作成し、写真を設定します。
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        let photo = photos[indexPath.item]
        if let urlString = photo.urls["regular"], let url = URL(string: urlString) {
            let authorName = photo.user.name
            cell.configure(with: url, author: authorName)
        }
        
        return cell
        
    }

    //コレクションビューのセクションヘッダーを利用するために使用
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        header.configure(title: "新着写真")
        return header
        
    }

    // アイテムのサイズを返すメソッドです。
    // 最初のアイテムは大きく表示し、それ以降は小さく表示します。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if indexPath.item == 0 {
            return CGSize(width: width, height: width) // 1枚目の画像を大きく表示
        } else {
            let smallerWidth = (width - 1) / 2
            return CGSize(width: smallerWidth, height: smallerWidth) // 2~5枚目の画像を小さく2列に表示
        }
        
    }

    // セクションのインセットを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // セクション内の行間スペースを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // 画像間のスペースを設定
    }

    // セクション内のアイテム間スペースを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // 画像間のスペースを設定
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "WallpaperDetailViewController") as? WallpaperDetailViewController else {
            return
        }
        let selectedPhoto = photos[indexPath.item]
        detailVC.imageUrl = selectedPhoto.urls["regular"]
        detailVC.authorName = selectedPhoto.user.name
        detailVC.source = selectedPhoto.user.location ?? "Location not available"
        detailVC.authorNameToPage = selectedPhoto.user.username

        // 日付フォーマッタを使用して更新日をフォーマット
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: selectedPhoto.updatedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy年MM月dd日"
            detailVC.updateDate = displayFormatter.string(from: date)
        } else {
            detailVC.updateDate = "Date not available"
        }

        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}	
