
import UIKit

class AppOverViewController: UIViewController {

    @IBOutlet weak var UnsplashLogoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // タップジェスチャーを作成し、unsplashLogoTappedメソッドと関連付け
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(unsplashLogoTapped))
        // 作成したタップジェスチャーをUnsplashLogoImageViewに追加
        UnsplashLogoImageView.addGestureRecognizer(tapGesture)
        // UnsplashLogoImageViewのユーザー操作を有効
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
