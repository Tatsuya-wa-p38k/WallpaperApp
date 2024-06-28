
import UIKit

// WallpaperCellという名前のクラスを定義します。	
// このクラスはUICollectionViewCellを継承し、コレクションビューのセルを管理します。
class WallpaperCell: UICollectionViewCell {
    @IBOutlet weak var wallpaperImageView: UIImageView!

    // セルに画像を設定するメソッドです。
    func configure(with url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.wallpaperImageView.image = image
            }
        }.resume() // タスクを開始します。
    }
}
