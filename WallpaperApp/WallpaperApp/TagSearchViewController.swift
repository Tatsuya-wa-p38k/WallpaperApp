
import UIKit

// Unsplash APIにアクセスするためのキーを定義
//外部から変更できないようにprivateで宣言
private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

class TagSearchAPI {
    // 指定された色に基づいて写真を取得するメソッド
    // このメソッドは非同期で動作し、完了時にクロージャーを呼び出す
    static func fetchPhotosByTag(color: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        // APIのURLを文字列として定義(指定された色の写真を取得するためのURL)
        let urlString = "https://api.unsplash.com/search/photos?query=\(color)&color=\(color)&per_page=5&client_id=\(accessKey)"
        // URLSessionを使用して指令されたデータを非同期で取得
        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _,error in
            // エラーがあれば、それを結果として返す。
            if let error = error {
                completion(.failure(error))
                return
            }

            // データが存在しない場合、カスタムエラーを作成して返す
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            // JSONデコードを試みる
            do {
                // JSONのキー名をスネークケースからキャメルケースに変換
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // データをPhoto構造体の配列にデコード
                let photoResults = try decoder.decode(PhotoResults.self, from: data)
                completion(.success(photoResults.results))
            } catch {
                // デコードに失敗した場合、エラーを結果として返す
                completion(.failure(error))
            }
        }.resume() // データタスクを開始
    }
}

// TagSearchViewControllerクラスの定義
// タグ検索画面のUIと動作を管理
class TagSearchViewController: UIViewController {
    // UICollectionViewのアウトレット接続
    @IBOutlet weak var tagCollectionView: UICollectionView!
    // 色選択ボタンのアウトレット接続
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    // 取得した写真を格納する配列
    private var photos: [Photo] = []
    var selectedColor: String = "red" //最初に表示される色
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupButtons()
        fetchPhotos()
    }
    
    // コレクションビューの初期設定を行うプライベートメソッド
    private func setupCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    // ボタンの初期設定を行うプライベートメソッド
    private func setupButtons() {
        let buttons = [redButton, blueButton, greenButton, yellowButton, whiteButton, blackButton]
        for button in buttons {
            button?.layer.cornerRadius = 6 // 角を丸くする
            button?.layer.masksToBounds = true  //角の丸みを適用
            button?.layer.borderWidth = 1 // 枠線の幅を設定
            button?.layer.borderColor = UIColor.black.cgColor // 枠線の色を黒に設定
            // ボタンのフォントを設定
            if let currentFontSize = button?.titleLabel?.font.pointSize {
                button?.titleLabel?.font = UIFont.systemFont(ofSize: currentFontSize, weight: .semibold)
            } else {
                button?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
            }
        }
    }
    
    // 写真を取得するプライベートメソッド
    private func fetchPhotos() {
        TagSearchAPI.fetchPhotosByTag(color: selectedColor) { [weak self] result in
            switch result {
            case .success(let photos):
                // 成功した場合、写真を保存してコレクションビューを更新
                self?.photos = photos
                DispatchQueue.main.async {
                    self?.tagCollectionView.reloadData()
                }
            case .failure(let error):
                // 失敗した場合、エラーメッセージを出力
                print("Failed to fetch photos: \(error.localizedDescription)")
            }
        }
    }
    
    // 各色ボタンのアクションメソッド
    @IBAction func redTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "red"
        fetchPhotos()
        // 押したボタンの文字色と背景色を変更する
        redButton.backgroundColor = .black
        redButton.tintColor = .white
    }
    
    @IBAction func blueTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "blue"
        fetchPhotos()
        // 押したボタンの文字色と背景色を変更する
        blueButton.backgroundColor = .black
        blueButton.tintColor = .white
    }
    
    @IBAction func greenTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "green"
        fetchPhotos()
        // 押したボタンの文字色と背景色を変更する
        greenButton.backgroundColor = .black
        greenButton.tintColor = .white
    }
    
    @IBAction func yellowTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "yellow"
        fetchPhotos()
        // 押したボタンの文字色と背景色を変更する
        yellowButton.backgroundColor = .black
        yellowButton.tintColor = .white
    }
    
    @IBAction func whiteTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "white"
        fetchPhotos()
        // 押したボタンの文字色と背景色を変更する
        whiteButton.backgroundColor = .black
        whiteButton.tintColor = .white
    }
    
    @IBAction func blackTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "black"
        fetchPhotos()
        // 押したボタンの文字色と背景色を変更する
        blackButton.backgroundColor = .black
        blackButton.tintColor = .white
    }
    // すべてのボタンの色をリセットするプライベートメソッド
    private func resetButtonColors() {
        let buttons = [redButton, blueButton, greenButton, yellowButton, whiteButton, blackButton]
        for button in buttons {
            button?.backgroundColor = .clear
            button?.tintColor = .black
        }
    }
}
// TagSearchViewControllerの拡張
// UICollectionViewDataSourceとUICollectionViewDelegateFlowLayoutプロトコルを実装
extension TagSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // セクション内のアイテム数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    // 各セルの内容を設定するメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
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
    // セクション内の行間の最小スペースを返すメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    // コレクションビューのアイテムが選択されたときに呼ばれるメソッド
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 詳細画面のビューコントローラーを生成
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "WallpaperDetailViewController") as? WallpaperDetailViewController else {
            return
        }
        // 選択された写真の情報を詳細画面に渡す
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
        // alternative_slugsのja（日本語の代替タイトル）の情報を渡す
        detailVC.alternativeSlugJa = selectedPhoto.alternativeSlugs["ja"]
        // 詳細画面に遷移
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

