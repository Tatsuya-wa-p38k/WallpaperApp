
import UIKit

class WallpaperDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    var imageUrl: String?
    var authorName: String?
    var source: String?
    var updateDate: String?
    var authorNameToPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorLabel.text = authorName
        sourceLabel.text = source
        updateLabel.text = updateDate

        if let imageUrl = imageUrl {
            loadImage(from: imageUrl)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped))
         authorLabel.addGestureRecognizer(tapGesture)
         authorLabel.isUserInteractionEnabled = true
    }

    @objc func authorLabelTapped() {
        guard let authorNameToPage = authorNameToPage else { return }

        let authorURLString = "https://unsplash.com/ja/@\(authorNameToPage)"
        guard let authorURL = URL(string: authorURLString) else { return }

        let authorPageVC = AuthorPageViewController()
        authorPageVC.authorURL = authorURL
        authorPageVC.modalPresentationStyle = .automatic // モーダル表示のスタイルを設定
        present(authorPageVC, animated: true, completion: nil)

        print(authorURLString)
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.detailImageView.image = image
                }
            }
        }
        task.resume()
    }
}
