import UIKit
// WebKitフレームワークをインポートすることにより、WKWebViewクラスが使用可能
import WebKit

class ResultSearchViewController: UIViewController {

    // URLを文字列として保持する変数を宣言します。オプショナル型なので、値がない場合を考慮
    var urlString: String?
    // WKWebViewのインスタンスを保持する変数を宣言し、privateキーワードにより、このクラス内でのみアクセス可
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewを作成し、ビュー全体を覆うように設定
        webView = WKWebView(frame: self.view.frame)
        // 作成したWebViewをビューに追加
        self.view.addSubview(webView)

        // urlStringが存在し、それが有効なURLに変換できる場合の処理を実行
        if let urlString = urlString, let url = URL(string: urlString) {
            // URLRequestを作成
            let request = URLRequest(url: url)
            // WebViewでURLRequestをロード
            webView.load(request)
        }
    }
}
