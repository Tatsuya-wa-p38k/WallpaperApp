import UIKit

// Unsplash APIにアクセスするためのキーを定義
private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

class UnsplashAPI {
    //新着写真５枚を取ってくるためのメソッドを定義
    static func fetchPhotos(completion: @escaping ([Photo]?) -> Void) {
        // APIのURLを文字列として定義
        let urlString = "https://api.unsplash.com/photos/?per_page=5&order_by=latest&client_id=\(accessKey)"
        // URLオブジェクトを生成
        // 文字列が正しいURLでない場合、nilを返して終了
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // URLセッションを使用して、指定したURLからデータを非同期で取得
        URLSession.shared.dataTask(with: url) { data, response, error in
            // データが取得でき、エラーがないかを確認
            guard let data = data, error == nil else {
                print("データの取得に失敗しました: \(error?.localizedDescription ?? "エラーなし")")
                completion(nil)
                return
            }
            do {
                // 取得したデータをPhoto構造体の配列に変換
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photos = try decoder.decode([Photo].self, from: data)
                completion(photos)
            } catch {
                // デコードに失敗した場合、エラーメッセージを表示してnilを返す
                print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()// タスクを開始
    }
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var wallpaperCollectionView: UICollectionView!
    // 写真の配列を保持するためのプロパティ
    private var photos: [Photo] = []

    // ビューがロードされたときに呼ばれるメソッドで
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // SectionHeaderを登録
        wallpaperCollectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"SectionHeader")

        // コレクションビューのレイアウトを設定
        // 画像間のスペースを0に設定
        if let flowLayout = wallpaperCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }

        // UnsplashAPIから写真を取得
        UnsplashAPI.fetchPhotos { [weak self] photos in
            // 取得した写真をプロパティに保存し、コレクションビューをリロード
            guard let self = self, let photos = photos else { return }
            self.photos = photos
            DispatchQueue.main.async {
                self.wallpaperCollectionView.reloadData()
            }
        }

        wallpaperCollectionView.delegate = self
        wallpaperCollectionView.dataSource = self

    }

    // コレクションビューのアイテム数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    // セルを作成し、写真を設定
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

    // コレクションビューのセクションのインセットを設定するメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // アイテムのサイズを返すメソッド
    // 最初のアイテムは大きく表示し、それ以降は小さく表示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if indexPath.item == 0 {
            return CGSize(width: width, height: width) // 1枚目の画像を大きく表示
        } else {
            let smallerWidth = (width - 15) / 2 // 左右のスペースを考慮して計算
            return CGSize(width: smallerWidth, height: smallerWidth) // 2~5枚目の画像を小さく2列に表示
        }
    }

    // コレクションビューの行間スペースを設定するメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // 上下の画像間のスペースを設定
    }

    // コレクションビューのアイテムが選択されたときに呼び出されるメソッド
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

        // alternative_slugsのjaの情報を渡す
        detailVC.alternativeSlugJa = selectedPhoto.alternativeSlugs["ja"]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}	
