
import UIKit

// Unsplash APIにアクセスするためのキーを定義します。
// これはAPIを使うためのパスワードのようなものです。
private let accessKey = "5mZ1mWYN9YDqITBv29Lvacog0cUPus5RwqDCeQeHHHc"

// このクラスには、Unsplash APIから写真を取得する機能があります。
class TagSearchAPI {
    static func fetchPhotosByTag(parameters: TagSearchParameters, completion: @escaping ([Photo]?) -> Void) {
        // APIのURLを文字列として定義します。
        let urlString = "https://api.unsplash.com/search/photos?query=\(parameters.query)&color=\(parameters.color)&per_page=\(parameters.perPage)&client_id=\(accessKey)"
        // URLオブジェクトを生成します。
        // 文字列が正しいURLでない場合、nilを返して終了します。œ
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
                // 取得したデータをPhotoResultsの配列に変換します。
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photoResults = try decoder.decode(PhotoResults.self, from: data)
                completion(photoResults.results)
            } catch {
                print("JSONのデコードに失敗しました: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()// タスクを開始します。
    }
    
}

class TagSearchViewController: UIViewController, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var tagCollectionView: UICollectionView!

    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!

    private var photos: [Photo] = []
    var selectedColor: String = "yellow" // 例: ユーザーが選択した色

    // ビューがロードされたときに呼ばれるメソッドです。
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 1 // 画像間のスペースを1に設定
            flowLayout.minimumLineSpacing = 1 // 行間のスペースを1に設定
        }
        
        setupButtons()
        fetchPhotosForSelectedTag()
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func setupButtons() {
        let buttons = [redButton, blueButton, greenButton, yellowButton, whiteButton, blackButton]
        for button in buttons {
            button?.layer.cornerRadius = 6 // 角を丸くする半径を指定
            button?.layer.borderWidth = 1 // 枠線の幅を設定
            button?.layer.borderColor = UIColor.black.cgColor // 枠線の色を設定
            button?.layer.masksToBounds = true // 角を丸くする

            if let currentFontSize = button?.titleLabel?.font.pointSize {
                button?.titleLabel?.font = UIFont.systemFont(ofSize: currentFontSize, weight: .semibold)
            } else {
                button?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
            }
        }
    }

    @IBAction func redTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "red"
        fetchPhotosForSelectedTag()
        // ボタンの文字色と背景色を変更する
        redButton.backgroundColor = .black
        redButton.tintColor = .white
    }
    
    @IBAction func blueTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "blue"
        fetchPhotosForSelectedTag()
        // ボタンの文字色と背景色を変更する
        blueButton.backgroundColor = .black
        blueButton.tintColor = .white
    }
    
    @IBAction func greenTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "green"
        fetchPhotosForSelectedTag()
        // ボタンの文字色と背景色を変更する
        greenButton.backgroundColor = .black
        greenButton.tintColor = .white
    }
    
    @IBAction func yellowTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "yellow"
        fetchPhotosForSelectedTag()
        yellowButton.backgroundColor = .black
        yellowButton.tintColor = .white
    }
    
    @IBAction func whiteTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "white"
        fetchPhotosForSelectedTag()
        whiteButton.backgroundColor = .black
        whiteButton.tintColor = .white
    }
    
    @IBAction func blackTagButton(_ sender: Any) {
        resetButtonColors()
        selectedColor = "black"
        fetchPhotosForSelectedTag()
        blackButton.backgroundColor = .black
        blackButton.tintColor = .white
    }

    private func resetButtonColors() {
        let buttons = [redButton, blueButton, greenButton, yellowButton, whiteButton, blackButton]
        for button in buttons {
            button?.backgroundColor = .clear
            button?.tintColor = .black
        }
    }
    
    private func fetchPhotosForSelectedTag() {
        let parameters = TagSearchParameters(
            query: selectedColor,
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let photo = photos[indexPath.item]
        if let urlString = photo.urls["regular"], let url = URL(string: urlString) {
            let authorName = photo.user.name
            cell.configure(with: url, author: authorName)
        }
        return cell
    }

    // アイテムのサイズを返すメソッドです。
    // 最初のアイテムは大きく表示し、それ以降は小さく表示します。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if indexPath.item == 0 {
            return CGSize(width: width, height: width) // 1枚目の画像を大きく表示
        } else {
            let numberOfItemsPerRow: CGFloat = 2
            let spacingBetweenItems: CGFloat = 15
            let totalSpacing = (numberOfItemsPerRow - 1) * spacingBetweenItems
            let itemWidth = (width - totalSpacing) / numberOfItemsPerRow
            return CGSize(width: itemWidth, height: itemWidth) // 2~5枚目の画像を小さく2列に表示
        }
    }

    // セクションのインセットを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // セクション内の行間スペースを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // 上下の画像間のスペースを設定
    }

    // セクション内のアイテム間スペースを返すメソッドです。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // 左右の画像間のスペースを設定
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


