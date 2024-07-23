
import UIKit

// SearchCellという名前のクラスを定義、
// コレクションビュー内の各セルの振る舞いと外観を定義
class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var searchImageVIew: UIImageView!
    @IBOutlet weak var searchAuthorView: UIView!
    @IBOutlet weak var searchAuthorLabel: UILabel!

    // セルがInterface Builderからロードされたときに呼ばれるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()

        setupAuthorView()  // authorViewの設定を行うカスタムメソッドを呼び出し
        searchImageVIew.layer.cornerRadius = 10 // searchImageVIewの角を丸く設定
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

    // configure(with:author:)メソッドは、セルに画像URLと作者名を設定するために使用されます。
    func configure(with url: URL, author: String) {
        // URLから画像を非同期で読み込みます。
        // DispatchQueue.global().asyncを使用してバックグラウンドスレッドで処理を行い、
        // メインスレッドをブロックしないようにします。
         DispatchQueue.global().async {
             // URLから画像データを取得しようとします。
             if let data = try? Data(contentsOf: url) {
                 // 画像データの取得に成功したら、メインスレッドでUIを更新します。
                 DispatchQueue.main.async {
                     // 取得したデータからUIImageを作成し、imageViewに設定します。
                     self.searchImageVIew.image = UIImage(data: data)
                 }
             }
         }
        // 作者名をラベルに設定します。
         self.searchAuthorLabel.text = author
     }
}

