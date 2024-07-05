
import UIKit

// フッターに表示するタブの種類を定義する列挙型
enum FooterTab {
    case home
    case tagSearch
    case appOverView
    case search
}

// FooterTabViewのデリゲートプロトコルを定義
// フッターメニューのタブが選択されたときに呼び出されるメソッドを持つ
protocol FooterTabViewDelegate: AnyObject {
    func footerTabView(_ footerTabView: FooterTabView, didselectTab: FooterTab)
}

// フッターメニューのビューを定義するクラス
class FooterTabView: UIView {

    // Interface Builderで接続された影のビュー
    @IBOutlet weak var shadowView: UIView!
    // Interface Builderで接続された影のビュー
    @IBOutlet weak var contentView: UIView!

    // FooterTabViewDelegateのインスタンスを保持
    var delegate: FooterTabViewDelegate?

    // ホームタブがタップされたときに呼び出されるアクション
    @IBAction func didTapHome(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .home)
    }

    // タグ検索タブがタップされたときに呼び出されるアクション
    @IBAction func didTapTagSearch(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .tagSearch)
    }

    // アプリ概要タブがタップされたときに呼び出されるアクション
    @IBAction func didTapAppOverView(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .appOverView)
    }

    @IBAction func didTapSearch(_ sender: Any)
        {
            delegate?.footerTabView(self, didselectTab: .search)
    }

    //カスタムビューの初期化メソッド
    override init(frame: CGRect) {
        super.init(frame: frame)
        load() // Nibファイルからビューをロード
        setup() // ビューの設定を行う
    }

    // カスタムビューの初期化メソッド（Interface Builderからインスタンス化された場合に呼び出される）
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load() // Nibファイルからビューをロード
        setup() // ビューの設定を行う
    }

    // ビューの設定を行うメソッド
    func setup() {
        // shadowViewに影を設定
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4

        // shadowViewとcontentViewの角を丸くする
        shadowView.layer.cornerRadius = 30
        contentView.layer.cornerRadius = 30

        // マスクを有効にすることで角を丸く表示
        shadowView.layer.masksToBounds = false
        contentView.layer.masksToBounds = true
    }

    // Nibファイルからビューをロードするメソッド
    func load() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)),
                                                               owner: self, options:nil)?.first as? UIView {
            view.frame = self.bounds // ロードしたビューのフレームを親ビューのサイズに設定
            self.addSubview(view) // ロードしたビューのフレームを親ビューのサイズに設定
        }
    }
}
