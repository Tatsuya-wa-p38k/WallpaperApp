
import UIKit

class WallpaperExpandViewController: UIViewController {

    @IBOutlet weak var expandedImageView: UIImageView!
    var imageUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 画像を設定
               if let imageUrl = imageUrl {
                   URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                       guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                       DispatchQueue.main.async {
                           self.expandedImageView.image = image
                       }
                   }.resume()
               }
           }
       }
