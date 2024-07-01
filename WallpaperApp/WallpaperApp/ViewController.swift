
import UIKit

class ViewController: UIViewController, FooterTabViewDelegate {

    @IBOutlet weak var footerTabView: FooterTabView! {
        didSet {
            footerTabView.delegate = self
        }
    }

    var selectedTab: FooterTab = .home

    override func viewDidLoad() {
         super.viewDidLoad()
        swichViewController(selectedTab: .home)
    }

    private lazy var homeViewController:HomeViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController =  storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        add(childViewController: viewController)
        return viewController
    }()

    //tagSearchのページにもfooter

//    private lazy var homeViewController:HomeViewController = {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var viewController =  storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//        add(childViewController: viewController)
//        return viewController
//    }()
//
//    private lazy var homeViewController:HomeViewController = {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var viewController =  storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//        add(childViewController: viewController)
//        return viewController
//    }()

    private func swichViewController(selectedTab: FooterTab) {
        switch selectedTab {
        case .home:
            add(childViewController: homeViewController)
//            remove(childViewController: tagSearchViewController)
//            remove(childViewController: appOverViewController)
//        case .tagSearch:
//            add(childViewController: tagSearchViewController)
//            remove(childViewController: homeViewController)
//            remove(childViewController: appOverViewController)
//        case .appOverView:
//            add(childViewController: appOverViewController)
//            remove(childViewController: homeViewController)
//            remove(childViewController: tagSearchViewController)
        }
        self.selectedTab = selectedTab
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
        // 処理を記述
    }

}

