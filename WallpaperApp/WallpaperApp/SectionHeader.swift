
import UIKit

class SectionHeader: UICollectionReusableView {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        titleLabel.text = title
    }
}
