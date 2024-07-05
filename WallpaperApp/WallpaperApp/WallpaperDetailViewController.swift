
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
        navigationItem.title = "表示したいタイトル"
        authorLabel.text = authorName
        sourceLabel.text = source
        updateLabel.text = updateDate

        if let imageUrl = imageUrl {
            loadImage(from: imageUrl)
        }

        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        detailImageView.addGestureRecognizer(imageTapGesture)
        detailImageView.isUserInteractionEnabled = true


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped))
         authorLabel.addGestureRecognizer(tapGesture)
         authorLabel.isUserInteractionEnabled = true
    }

    @objc func imageTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard名を"Main"に変更するか、使用しているStoryboard名に変更
        let expandVC = storyboard.instantiateViewController(withIdentifier: "WallpaperExpandViewController") as! WallpaperExpandViewController
        if let imageUrlString = imageUrl, let imageUrl = URL(string: imageUrlString) {
            expandVC.imageUrl = imageUrl
        }
        navigationController?.pushViewController(expandVC, animated: true)
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
