import UIKit
import WebKit

class ToUnsplashWebsiteViewController: UIViewController {
    var webView: WKWebView!
    private let topBarHeight: CGFloat = 58

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add WKWebView
        webView = WKWebView(frame: CGRect(x: 0, y: topBarHeight, width: self.view.frame.width, height: self.view.frame.height - topBarHeight))
        self.view.addSubview(webView)

        if let url = URL(string: "https://unsplash.com/") {
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
