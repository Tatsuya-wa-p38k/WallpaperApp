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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // 検索結果が見つからなかった場合に表示するラベルを追加
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.numberOfLines = 0 // 一行で省略表示(...)させないための機能
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         searchBar.delegate = self
         searchBar.placeholder = "写真とイラストを検索"
         searchBar.autocapitalizationType = .none // 入力された最初の文字が自動的に大文字にならないための処理
         
         if let flowLayout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
             flowLayout.minimumInteritemSpacing = 0
             flowLayout.minimumLineSpacing = 0
         }
         
         searchCollectionView.delegate = self
         searchCollectionView.dataSource = self
         
         // noResultsLabelをビューに追加
         view.addSubview(noResultsLabel)
         
         // noResultsLabelの制約を設定
         NSLayoutConstraint.activate([
             noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
             noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
         ])
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    // UISearchBarDelegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        view.endEditing(true)
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
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let photos = photos, !photos.isEmpty {
                    self.photos = photos
                    self.noResultsLabel.isHidden = true
                } else {
                    self.photos = []
                    self.noResultsLabel.text = "\(query) に関する写真は見つかりませんでした。"
                    self.noResultsLabel.isHidden = false
                }
                self.searchCollectionView.reloadData()
            }
        }
    }
}
