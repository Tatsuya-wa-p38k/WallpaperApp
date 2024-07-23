import UIKit

// Unsplash APIにアクセスするためのキーを定義
//外部から変更できないようにprivateで宣言
private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

// UnsplashAPIクラスの定義、Unsplash APIとの通信を担当
class UnsplashAPI {
    //新着写真５枚を取得するためのメソッドを定義
    // このメソッドは非同期で動作し、完了時にクロージャーを呼び出す
    // Result型は成功(.success)または失敗(.failure)のどちらかの状態を持つ
    static func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        // APIのURLを文字列として定義(新着写真５枚を取得するためのURL)
        let urlString = "https://api.unsplash.com/photos/?per_page=5&order_by=latest&client_id=\(accessKey)"
        // URLSessionを使用して指令されたデータを非同期で取得
        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _,error in
            // エラーがあれば、それを結果として返す。
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // データが存在しない場合、カスタムエラーを作成して返す。
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            //JSONデコードを試みる
            do {
                // JSONデコーダーを作成
                let decoder = JSONDecoder()
                // JSONのキー名をスネークケースからキャメルケースに変換
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //データをPhoto構造体の配列にデコード
                let photos = try decoder.decode([Photo].self, from: data)
                //成功時には写真の配列を結果として返す
                completion(.success(photos))
            } catch {
                // デコードに失敗した場合、エラーを結果として返す。
                completion(.failure(error))
            }
        }.resume()// タスクを開始
    }
}

// HomeViewControllerクラスを定義、ホーム画面のUIと動作を管理
class HomeViewController: UIViewController {

    //CollectionViewのアウトレット接続
    @IBOutlet weak var wallpaperCollectionView: UICollectionView!

    // 写真の配列を保持するためのプロパティを定義
    private var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchPhotos()
        }

    // コレクションビューの初期設定を行うプライベートメソッド
    private func setupCollectionView() {
        // セクションヘッダーを登録
        // これにより、コレクションビューにカスタムヘッダーを使用できる
           wallpaperCollectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        // デリゲートとデータソースを設定
        // これにより、このViewControllerがコレクションビューの動作とデータを管理
           wallpaperCollectionView.delegate = self
           wallpaperCollectionView.dataSource = self
       }

    // 写真を取得するプライベートメソッド
       private func fetchPhotos() {
           UnsplashAPI.fetchPhotos { [weak self] result in
               switch result {
               case .success(let photos):
                   // 成功した場合、写真を保存してコレクションビューを更新
                   self?.photos = photos
                   DispatchQueue.main.async {
                       self?.wallpaperCollectionView.reloadData()
                   }
               case .failure(let error):
                   // 失敗した場合、エラーメッセージを出力
                   print("Failed to fetch photos: \(error.localizedDescription)")
               }
           }
       }
   }
// HomeViewControllerの拡張。UICollectionViewDataSourceとUICollectionViewDelegateFlowLayoutプロトコルを実装
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // セクション内のアイテム数(画像)を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    // 各セルの内容を設定するメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
         let photo = photos[indexPath.item]
         if let urlString = photo.urls["regular"], let url = URL(string: urlString) {
             let authorName = photo.user.name
             cell.configure(with: url, author: authorName)
         }
         return cell
     }
    // 各アイテムのサイズを返すメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return indexPath.item == 0 ? CGSize(width: width, height: width) : CGSize(width: (width - 15) / 2, height: (width - 15) / 2)
    }

    // セル間の縦方向の最小間隔を設定するメソッド
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    // セクションヘッダーを設定するメソッド
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        header.configure(title: "新着写真")
        return header
    }
    // コレクションビューのアイテム(写真)が選択された(タップされた)ときに呼び出される関数
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 詳細画面のビューコントローラーを生成
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "WallpaperDetailViewController") as? WallpaperDetailViewController else {
            return
        }
        // 選択された写真の情報を詳細画面WallpaperDetailViewControllerに渡す
        let selectedPhoto = photos[indexPath.item] //選択されたアイテムの位置
        detailVC.imageUrl = selectedPhoto.urls["regular"]
        detailVC.authorName = selectedPhoto.user.name
        detailVC.source = selectedPhoto.user.location ?? "Location not available"
        detailVC.authorNameToPage = selectedPhoto.user.username

        // 日付フォーマッタを使用して更新日をフォーマット
        let formatter = ISO8601DateFormatter() //国際標準の日付形式を解析するためのフォーマッタ
        if let date = formatter.date(from: selectedPhoto.updatedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy年MM月dd日" //日付を指定した形式の文字列に変換するためのフォーマッタ
            detailVC.updateDate = displayFormatter.string(from: date)
        } else {
            detailVC.updateDate = "Date not available"
        }
        
        // alternative_slugsのja代替タイトル(日本語)の情報を渡す
        detailVC.alternativeSlugJa = selectedPhoto.alternativeSlugs["ja"] //代替タイトルを含む辞書
        
        // 詳細画面に遷移
        navigationController?.pushViewController(detailVC, animated: true)
    }
}	
