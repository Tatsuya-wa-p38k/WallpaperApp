import UIKit

class TagCell: UICollectionViewCell {


    @IBOutlet weak var tagImageView: UIImageView!

    func configure(with url: URL) {
        // URLから画像を非同期でロードする
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.tagImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
