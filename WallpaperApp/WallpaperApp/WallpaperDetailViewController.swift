
import UIKit

class WallpaperDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    // 画像のURLを保持する変数を定義
    var imageUrl: String?
    // 作者名を保持する変数を定義
    var authorName: String?
    // ソース情報を保持する変数を定義
    var source: String?
    // 更新日を保持する変数を定義
    var updateDate: String?
    // 作者ページへのリンク用ユーザー名を保持する変数を定義
    var authorNameToPage: String?
    // 代替スラッグ（日本語）を保持する変数を定義
    var alternativeSlugJa: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // alternativeSlugJaを整形してnavigationItem.titleに設定
        //日本語のタイトル以降に文字列[-英数字]を含むため、それを削除するcleanTitleメソッドを利用
        if let slug = alternativeSlugJa {
            navigationItem.title = cleanTitle(slug)
        } else {
            navigationItem.title = "写真の詳細"
        }
        // 各ラベルにテキストを設定
        authorLabel.text = authorName
        sourceLabel.text = source
        updateLabel.text = updateDate
        // 画像URLが存在する場合、画像をロード
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

    // 　写真のタイトルから不要な部分を削除するメソッドを定義
    func cleanTitle(_ title: String) -> String {
        // - 以降の部分を取り除く
        if let range = title.range(of: "-") {
            return String(title[..<range.lowerBound])
        }
        return title
    }

    // 画像がタップされたときに呼び出されるメソッドを定義
    @objc func imageTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard名を"Main"に変更するか、使用しているStoryboard名に変更
        let expandVC = storyboard.instantiateViewController(withIdentifier: "WallpaperExpandViewController") as! WallpaperExpandViewController
        if let imageUrlString = imageUrl, let imageUrl = URL(string: imageUrlString) {
            expandVC.imageUrl = imageUrl
        }
        navigationController?.pushViewController(expandVC, animated: true)
    }

    // 作者ラベルがタップされたときに呼び出されるメソッドを定義
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

    // 画像をURLから非同期でロードするプライベートメソッドを定義
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
