
import UIKit

// Unsplash APIにアクセスするためのキーを定義します。
// これはAPIを使うためのパスワードのようなものです。
private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

struct TagSearchParameters {
    let query: String
    let color: String
    let perPage: Int
}

// TagSearchAPIという名前のクラスを定義します。
// このクラスには、Unsplash APIから写真を取得する機能があります。
class TagSearchAPI {
    static func fetchPhotosByTag(parameters: TagSearchParameters, completion: @escaping ([Photo]?) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(parameters.query)&color=\(parameters.color)&per_page=\(parameters.perPage)&client_id=\(accessKey)"

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
                let photoResults = try decoder.decode(PhotoResults.self, from: data)
                completion(photoResults.results)
            } catch {
                print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct PhotoResults: Codable {
    let results: [Photo]
}

class TagSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tagCollectionView: UICollectionView!
    private var photos: [Photo] = []
    var selectedColor: String = "blue" // 例: ユーザーが選択した色

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotosForSelectedTag()
        setupCollectionView()
    }

    private func setupCollectionView() {
        if let flowLayout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }

    private func fetchPhotosForSelectedTag() {
        let parameters = TagSearchParameters(
            query: selectedColor, // 例: ユーザーが入力した検索ワード
            color: selectedColor,
            perPage: 5
        )
        TagSearchAPI.fetchPhotosByTag(parameters: parameters) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.photos = photos
            DispatchQueue.main.async {
                self.tagCollectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! WallpaperCell
        let photo = photos[indexPath.item]
        if let urlString = photo.urls["regular"], let url = URL(string: urlString) {
            cell.configure(with: url)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width) // 全ての画像を正方形フォーマットで表示
    }
}

