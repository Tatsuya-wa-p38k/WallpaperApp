
import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var searchImageVIew: UIImageView!
    @IBOutlet weak var searchAuthorView: UIView!
    @IBOutlet weak var searchAuthorLabel: UILabel!

    // セルがInterface Builderからロードされたときに呼ばれるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        // authorViewの設定を行うカスタムメソッドを呼び出します
        setupAuthorView()

        searchImageVIew.layer.cornerRadius = 10
    }

    // authorViewの外観を設定するためのメソッド
    private func setupAuthorView() {
        // authorViewの角を丸くします。値は必要に応じて調整可能です。
        searchAuthorView.layer.cornerRadius = 10
        // authorViewのどの角を丸くするかを指定します。
        // .layerMinXMinYCornerは左上の角、.layerMinXMaxYCornerは左下の角を指します。
        searchAuthorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        // 角を丸くした部分が親ビューの境界を超えないようにクリップします。
        searchAuthorView.clipsToBounds = true
    }

    func configure(with url: URL, author: String) {
         // URLから画像を読み込む
         DispatchQueue.global().async {
             if let data = try? Data(contentsOf: url) {
                 DispatchQueue.main.async {
                     self.searchImageVIew.image = UIImage(data: data)
                 }
             }
         }
         // 作者名を設定
         self.searchAuthorLabel.text = author
     }
}

