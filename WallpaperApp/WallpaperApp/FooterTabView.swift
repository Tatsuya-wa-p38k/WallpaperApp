
import UIKit

enum FooterTab {
    case home
    case tagSearch
    case appOverView
}

protocol FooterTabViewDelegate: AnyObject {
    func footerTabView(_ footerTabView: FooterTabView, didselectTab: FooterTab)
}

class FooterTabView: UIView {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentView: UIView!

    var delegate: FooterTabViewDelegate?

    @IBAction func didTapHome(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .home)
    }

    @IBAction func didTapTagSearch(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .tagSearch)
    }

    @IBAction func didTapAppOverView(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .appOverView)
    }

    //カスタムビューの初期化メソッド
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
        setup()
    }

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

    func load() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)),
                                                               owner: self, options:nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}
