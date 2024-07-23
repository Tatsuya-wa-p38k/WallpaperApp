
import UIKit

class WallpaperExpandViewController: UIViewController {

    @IBOutlet weak var expandedImageView: UIImageView!

    var imageUrl: URL?
    // 画像のURLを保持する変数を定義、オプショナル型のURL型
    // 画像のURLが設定されていない可能性を考慮

    override func viewDidLoad() {
        super.viewDidLoad()
        // 画像を設定
               if let imageUrl = imageUrl {
                   // imageUrlがnilでない場合（つまり、有効なURLが設定されている場合）に実行されるブロック

                   URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                       // URLSessionを使用して、指定されたURLから非同期でデータをダウンロード
                       // これにより、ネットワーク操作がメインスレッドをブロックしない

                       guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                       // ダウンロードしたデータが有効で、エラーがなく、そのデータから画像を生成できる場合にのみ
                       // 以降の処理を続行します。それ以外の場合は、この関数を終了

                       DispatchQueue.main.async {
                           // メインディスパッチキュー（UIの更新を行うスレッド）で以下の処理を実行
                           
                           self.expandedImageView.image = image
                           // ダウンロードして生成した画像を、expandedImageViewに設定
                       }
                   }.resume()
                   // データタスクを開始。resume()を呼び出すまで、実際のダウンロードは開始されず
               }
           }
       }
