import UIKit
// WebKitフレームワークをインポート、WKWebViewを使用するために必要
import WebKit

class AuthorPageViewController: UIViewController {
    // 作者のページURLを保持する変数を定義
    var authorURL: URL?
    // WebViewのインスタンスを保持する変数を宣言
    private var webView: WKWebView!
    // 上部バーの高さを定義する定数を宣言
    private let topBarHeight: CGFloat = 58

    override func viewDidLoad() {
        super.viewDidLoad()

        // WebViewのフレームを調整し、作成
        webView = WKWebView(frame: CGRect(x: 0, y: topBarHeight, width: self.view.frame.width, height: self.view.frame.height - topBarHeight))
        // 作成したWebViewをビューに追加
        self.view.addSubview(webView)
        // authorURLが設定されている場合、そのURLをロードします。
        if let url = authorURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        // 上部の余白ビューを作成
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topBarHeight))
        topBar.backgroundColor = .white
        self.view.addSubview(topBar)

        // 閉じるボタンを作成して配置
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: self.view.frame.width - 80, y: (topBarHeight - 30) / 2, width: 70, height: 30) // 右側上下中央に配置
        topBar.addSubview(closeButton)
    }

    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
