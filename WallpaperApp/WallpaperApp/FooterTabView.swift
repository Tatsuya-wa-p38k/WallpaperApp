
import UIKit

enum FooterTab {
    case home
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
        // shadowViewに影と丸みを付ける
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 30
        shadowView.layer.cornerRadius = 30
        contentView.clipsToBounds = true

        // contentViewに丸みを付ける
        contentView.layer.cornerRadius = 30
        contentView.clipsToBounds = true
    }

    func load() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)),
                                                               owner: self, options:nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}
