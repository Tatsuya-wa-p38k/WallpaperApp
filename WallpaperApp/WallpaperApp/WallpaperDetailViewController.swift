
import UIKit

class WallpaperDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    var imageUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 画像を設定
        if let imageUrl = imageUrl {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.detailImageView.image = image

                    // タップジェスチャーを追加
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                    self.detailImageView.addGestureRecognizer(tapGesture)
                    self.detailImageView.isUserInteractionEnabled = true
                }
            }.resume() // タスクを開始します。
        }
    }
    
    // 画像がタップされたときに呼ばれるメソッド
    @objc func imageTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let expandVC = storyboard.instantiateViewController(withIdentifier: "WallpaperExpandViewController") as? WallpaperExpandViewController {
            expandVC.imageUrl = imageUrl
            navigationController?.pushViewController(expandVC, animated: true)
        }
    }
}
