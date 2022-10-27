import RxSwift
import UIKit

class BaseViewController: UIViewController, CanHandleError {
    var dependencies: Dependencies! {
        didSet {
            dependenciesSet()
        }
    }

    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    /* override method for observing the dependencies instance */
    func dependenciesSet() {}
    
    func handleError(with error: APIErrorModel) {
        handleError(with: error, closure: nil)
    }
    
    func handleError(with error: APIErrorModel, closure: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: error.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok".localizedUppercase, style: UIAlertAction.Style.default, handler: { _ in
            if let closure = closure {
                closure()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
