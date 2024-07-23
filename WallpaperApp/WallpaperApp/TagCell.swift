
import UIKit

// UICollectionViewCellを継承したTagCellクラスを定義
// コレクションビュー内の各セルの振る舞いを定義
class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorView: UIView!

    // セルがInterface Builderからロードされたときに呼ばれるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()

        setupAuthorView()// authorViewの設定を行うカスタムメソッドを呼び出す
        tagImageView.layer.cornerRadius = 10//tagImageViewの角を丸くする
    }

    // authorViewの外観を設定するためのメソッド
    private func setupAuthorView() {
        authorView.layer.cornerRadius = 10 // authorViewの角を丸くする
        // authorViewのどの角を丸くするかを指定。
        // .layerMinXMinYCornerは左上の角、.layerMinXMaxYCornerは左下の角
        authorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        // 角を丸くした部分が親ビューの境界を超えないようにクリップ
        authorView.clipsToBounds = true
    }


    // セルの内容を設定するためのメソッド
    // URLから画像を読み込み、作者名を設定
    func configure(with url: URL, author: String) {
        // URLから画像を非同期で読み込み
                 // バックグラウンドスレッドで実行することで、
                 // メインスレッド（UI操作を行うスレッド）をブロックしないように
         DispatchQueue.global().async {
             if let data = try? Data(contentsOf: url) {
                 // 画像データの取得に成功したら、メインスレッドで
                 // UIImageViewに画像を設定
                 DispatchQueue.main.async {
                     self.tagImageView.image = UIImage(data: data)
                 }
             }
         }
         // 作者名をラベルに設定
         self.authorLabel.text = author
     }
}
