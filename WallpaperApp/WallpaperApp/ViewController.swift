
import UIKit

// ViewControllerはUIViewControllerを継承し、FooterTabViewDelegateプロトコルを採用しています
class ViewController: UIViewController, FooterTabViewDelegate {

    // FooterTabViewのアウトレットプロパティ
    @IBOutlet weak var footerTabView: FooterTabView! {
        // footerTabViewが設定されたときにデリゲートをselfに設定
        didSet {
            footerTabView.delegate = self
        }
    }

    // 現在選択されているタブを保持するプロパティ
    var selectedTab: FooterTab = .home

    // ビューがロードされた後に呼ばれるメソッド
    override func viewDidLoad() {
         super.viewDidLoad()
        // 初期表示でホームタブのビューコントローラーを表示
        switchViewController(selectedTab: .home)
    }

    //homeViewControllerにもfooterTabを
    private lazy var homeViewController:HomeViewController = {
        // Main.storyboardからHomeViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        // 子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    //tagSearchViewControllerにもfooterTabを
    private lazy var tagSearchViewController:TagSearchViewController = {
        // Main.storyboardからTagSearchViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "TagSearchViewController") as! TagSearchViewController
        // 子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    private lazy var appOverViewController:AppOverViewController = {
        // Main.storyboardからAppOverViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "AppOverViewController") as! AppOverViewController
        // 子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    private lazy var searchViewController:SearchViewController = {
        //Main.storyboardからSearchViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as!
            SearchViewController
        //子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    private func switchViewController(selectedTab: FooterTab) {
        switch selectedTab {
        case .home:
            add(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            remove(childViewController: appOverViewController)
            remove(childViewController: searchViewController)
        case .tagSearch:
            add(childViewController: tagSearchViewController)
            remove(childViewController: homeViewController)
            remove(childViewController: appOverViewController)
            remove(childViewController: searchViewController)
        case .appOverView:
            add(childViewController: appOverViewController)
            remove(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            remove(childViewController: searchViewController)
        case .search:
            add(childViewController: searchViewController)
            remove(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            remove(childViewController: appOverViewController)
        }
        self.selectedTab = selectedTab
        // フッタービューを最前面に表示
        view.bringSubviewToFront(footerTabView)
    }

    //子ViewControllerを追加する
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
    }

    //子ViewControllerを削除する
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }

    func footerTabView(_ footerTabView: FooterTabView, didselectTab tab: FooterTab) {
        switchViewController(selectedTab: tab)
    }

}

