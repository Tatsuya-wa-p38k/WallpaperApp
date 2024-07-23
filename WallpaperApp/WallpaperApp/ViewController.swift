
import UIKit

// ViewControllerはUIViewControllerを継承し、FooterTabViewDelegateプロトコルを採用
class ViewController: UIViewController, FooterTabViewDelegate {

    // FooterTabViewのアウトレット
    @IBOutlet weak var footerTabView: FooterTabView! {
        // プロパティオブザーバー: footerTabViewが設定されたときに自動的に呼ばれる
        didSet {
            // 自身（ViewController）をフッタータブビューのデリゲートとして設定
            // これにより、タブの選択イベントを受け取れる
            footerTabView.delegate = self
        }
    }

    // 現在選択されているタブを保持するプロパティ
    var selectedTab: FooterTab = .home // デフォルトで新着写真のホームタブが選択されている

    override func viewDidLoad() {
         super.viewDidLoad()
        // アプリ起動時に最初に表示する画面としてホームタブのビューコントローラーを設定
        switchViewController(selectedTab: .home)
    }

    // HomeViewControllerのインスタンスを遅延生成するプロパティ
    // lazyキーワードにより、このプロパティが最初にアクセスされるまでインスタンス化されない
    private lazy var homeViewController:HomeViewController = {
        // Main.storyboardからHomeViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        // 子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    // TagSearchViewControllerのインスタンスを生成するプロパティ
    private lazy var tagSearchViewController:TagSearchViewController = {
        // Main.storyboardからTagSearchViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "TagSearchViewController") as! TagSearchViewController
        // 子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    // AppOverViewControllerのインスタンスを生成するプロパティ
    private lazy var appOverViewController:AppOverViewController = {
        // Main.storyboardからAppOverViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "AppOverViewController") as! AppOverViewController
        // 子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()

    // SearchViewControllerのインスタンスを生成するプロパティ
    private lazy var searchViewController:SearchViewController = {
        //Main.storyboardからSearchViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as!
            SearchViewController
        //子ビューコントローラーとして追加
        add(childViewController: viewController)
        return viewController
    }()
    
    // 選択されたタブに応じてビューコントローラーを切り替えるプライベートメソッド
    private func switchViewController(selectedTab: FooterTab) {
        switch selectedTab {
        case .home:
            // ホームタブが選択された場合の処理
            add(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            remove(childViewController: appOverViewController)
            remove(childViewController: searchViewController)
        case .tagSearch:
            // タグ検索タブが選択された場合の処理
            add(childViewController: tagSearchViewController)
            remove(childViewController: homeViewController)
            remove(childViewController: appOverViewController)
            remove(childViewController: searchViewController)
        case .appOverView:
            // アプリ概要タブが選択された場合の処理
            add(childViewController: appOverViewController)
            remove(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            remove(childViewController: searchViewController)
        case .search:
            // 検索タブが選択された場合の処理
            add(childViewController: searchViewController)
            remove(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            remove(childViewController: appOverViewController)
        }
        // 選択されたタブを更新
        self.selectedTab = selectedTab
        // フッタービューを最前面に表示
        view.bringSubviewToFront(footerTabView)
    }

    //子ViewControllerを追加する
    private func add(childViewController: UIViewController) {
        // 子ビューコントローラーを現在のビューコントローラーの子として追加
        addChild(childViewController)
        // 子ビューコントローラーのビューを現在のビューに追加
        view.addSubview(childViewController.view)
        // 子ビューコントローラーのビューのサイズを親ビューに合わせる
        childViewController.view.frame = view.bounds
        // 子ビューコントローラーのビューのサイズを自動調整
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 子ビューコントローラーの移動が完了したことを通知
        childViewController.didMove(toParent: self)
    }

    //子ViewControllerを削除する
    private func remove(childViewController: UIViewController) {
        // 子ビューコントローラーの削除を開始することを通知
        childViewController.willMove(toParent: nil)
        // 子ビューコントローラーのビューを親ビューから削除
        childViewController.view.removeFromSuperview()
        // 子ビューコントローラーを親から削除
        childViewController.removeFromParent()
    }
    //FooterTabViewDelegateプロトコルのメソッド
    // タブが選択されたときに呼ばれる
    func footerTabView(_ footerTabView: FooterTabView, didselectTab tab: FooterTab) {
        // 選択されたタブに応じてビューコントローラーを切り替え
        switchViewController(selectedTab: tab)
    }

}

