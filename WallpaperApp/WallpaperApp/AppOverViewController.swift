
import UIKit

class AppOverViewController: UIViewController {

    @IBOutlet weak var UnsplashLogoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(unsplashLogoTapped))
        UnsplashLogoImageView.addGestureRecognizer(tapGesture)
        UnsplashLogoImageView.isUserInteractionEnabled = true
    }

    @objc func unsplashLogoTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let toUnsplashWebsiteVC = storyboard.instantiateViewController(identifier: "ToUnsplashWebsiteViewController") as? ToUnsplashWebsiteViewController {
            toUnsplashWebsiteVC.modalPresentationStyle = .automatic
            present(toUnsplashWebsiteVC, animated: true, completion: nil)
        }
    }

}
