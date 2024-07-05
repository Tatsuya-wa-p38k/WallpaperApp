import UIKit

private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

class UnsplashSearchAPI {
    static func searchPhotos(query: String, completion: @escaping ([Photo]?) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?per_page=5&order_by=latest&&query=\(query)&client_id=\(accessKey)"
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
                let searchResults = try decoder.decode(PhotoResults.self, from: data)
                completion(searchResults.results)
            } catch {
                print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    private var photos: [Photo] = []

    // ビューがロードされたときに呼ばれるメソッドです。
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search photos"
        self.navigationItem.titleView = searchBar

        // コレクションビューのレイアウトを設定します。
        // 画像間のスペースを0に設定します。
        if let flowLayout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }

        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self

    }

    // UISearchBarDelegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchPhotos(query: query)
    }

    // セクション内のアイテム数を返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    // アイテムを返すメソッドです。
    // セルを作成し、写真を設定します。
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let photo = photos[indexPath.item]
        if let urlString = photo.urls["regular"], let url = URL(string: urlString) {
            let authorName = photo.user.name
            cell.configure(with: url, author: authorName)
        }

        return cell

    }

    // セクションのインセットを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // アイテムのサイズを返すメソッドです。
    // 最初のアイテムは大きく表示し、それ以降は小さく表示します。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if indexPath.item == 0 {
            return CGSize(width: width, height: width) // 1枚目の画像を大きく表示
        } else {
            let smallerWidth = (width - 15) / 2 // 左右のスペースを考慮して計算
            return CGSize(width: smallerWidth, height: smallerWidth) // 2~5枚目の画像を小さく2列に表示
        }
    }

    // セクション内の行間スペースを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // 上下の画像間のスペースを設定
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

    private func searchPhotos(query: String) {
        UnsplashSearchAPI.searchPhotos(query: query) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.photos = photos
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }

}
