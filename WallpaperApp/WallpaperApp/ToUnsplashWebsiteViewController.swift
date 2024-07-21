import UIKit
import WebKit// WebKitフレームワークをインポートすることにより、WKWebViewクラスが使用可能

class ToUnsplashWebsiteViewController: UIViewController {
    var webView: WKWebView!// WKWebViewのインスタンスを保持する変数を宣言します。
    private let topBarHeight: CGFloat = 58 // 上部バーの高さを定義する定数を宣言します。

    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewを作成し、ビューに追加
        webView = WKWebView(frame: CGRect(x: 0, y: topBarHeight, width: self.view.frame.width, height: self.view.frame.height - topBarHeight))
        self.view.addSubview(webView)
        // Unsplashのウェブサイトを開くURLリクエストを作成し、ロード
        if let url = URL(string: "https://unsplash.com/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        // 上部の余白ビューを作成
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topBarHeight))
        topBar.backgroundColor = .white
        self.view.addSubview(topBar)

        // 閉じるボタンを作成して配置するためのコード
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        // ボタンがタップされたときにcloseButtonTappedメソッドを呼び出すように設定
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        // ボタンの位置とサイズを設定します。右側上下中央に配置
        closeButton.frame = CGRect(x: self.view.frame.width - 80, y: (topBarHeight - 30) / 2, width: 70, height: 30)
        topBar.addSubview(closeButton)
    }
    // 閉じるボタンがタップされたときに呼び出されるメソッド
    @objc func closeButtonTapped() {
        // 現在のビューコントローラーを閉じる=画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
