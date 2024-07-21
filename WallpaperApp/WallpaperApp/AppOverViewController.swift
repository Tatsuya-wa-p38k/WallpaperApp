
import UIKit

class AppOverViewController: UIViewController {

    @IBOutlet weak var UnsplashLogoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    // UITapGestureRecognizerを作成=タップジェスチャーを検出するためのオブジェクト
    // targetにselfを指定し、actionにunsplashLogoTappedメソッドを指定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(unsplashLogoTapped))
        // 作成したタップジェスチャーをUnsplashLogoImageViewに追加
        UnsplashLogoImageView.addGestureRecognizer(tapGesture)
        // UnsplashLogoImageViewのユーザー操作を有効し、タップ検出を可にする
        UnsplashLogoImageView.isUserInteractionEnabled = true
    }

    // Unsplashロゴがタップされたときに呼び出されるメソッド
    @objc func unsplashLogoTapped() {
        // "Main"という名前のストーリーボードを取得
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let toUnsplashWebsiteVC = storyboard.instantiateViewController(identifier: "ToUnsplashWebsiteViewController") as? ToUnsplashWebsiteViewController {
            // 新しいビューコントローラーの表示スタイルを下記で設定
            toUnsplashWebsiteVC.modalPresentationStyle = .automatic
            present(toUnsplashWebsiteVC, animated: true, completion: nil)
        }
    }

}
