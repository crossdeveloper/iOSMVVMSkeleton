import UIKit

class MainViewController: BaseViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NSClassFromString("XCTest") == nil {
            prepare()
        }
    }
}

private extension MainViewController {
    func prepare() {
        if let _ = dependencies.tokenManager.getApiKey() {
            self.userHasLoggedIn()
        } else {
            dependencies.loginManager.beginLogin { [weak self] success, error in
                if success {
                    self?.userHasLoggedIn()
                } else if let error = error {
                    self?.handleError(with: error)
                }
            }
        }
    }

    func userHasLoggedIn() {
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            let appDeleate = UIApplication.shared.delegate as? AppDelegate
            let vc = PostsViewController()
            vc.dependencies = dependencies
            vc.modalTransitionStyle = .crossDissolve
            appDeleate?.setRootFromScence(vc: vc, window: sceneDelegate.window)
        } else {
            let appDeleate = UIApplication.shared.delegate as? AppDelegate
            let vc = PostsViewController()
            vc.dependencies = dependencies
            vc.modalTransitionStyle = .crossDissolve
            appDeleate?.setRoot(vc: vc)
        }
    }
}
