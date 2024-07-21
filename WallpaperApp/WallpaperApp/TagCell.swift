import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorView: UIView!

    // セルがInterface Builderからロードされたときに呼ばれるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        // authorViewの設定を行うカスタムメソッドを呼び出します
        setupAuthorView()
        //tagImageViewの角を丸くする
        tagImageView.layer.cornerRadius = 10
    }

    // authorViewの外観を設定するためのメソッド
    private func setupAuthorView() {
        // authorViewの角を丸くする
        authorView.layer.cornerRadius = 10
        // authorViewのどの角を丸くするかを指定。
        // .layerMinXMinYCornerは左上の角、.layerMinXMaxYCornerは左下の角
        authorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        // 角を丸くした部分が親ビューの境界を超えないようにクリップ
        authorView.clipsToBounds = true
    }

    func configure(with url: URL, author: String) {
         // URLから画像を読み込む
         DispatchQueue.global().async {
             if let data = try? Data(contentsOf: url) {
                 DispatchQueue.main.async {
                     self.tagImageView.image = UIImage(data: data)
                 }
             }
         }
         // 作者名を設定
         self.authorLabel.text = author
     }
}
