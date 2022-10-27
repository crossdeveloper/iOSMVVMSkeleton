import RxSwift
import UIKit

class BaseViewModel: NSObject {
    let dependencies: Dependencies
    var disposeBag = DisposeBag()
    
    weak var errorDelegate: CanHandleError?

    init(dependencies: Dependencies, errorDelegate: CanHandleError? = nil) {
        self.dependencies = dependencies
        self.errorDelegate = errorDelegate
    }
}
