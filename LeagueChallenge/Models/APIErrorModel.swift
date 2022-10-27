import UIKit

protocol CanHandleError: AnyObject {
    func handleError(with error: APIErrorModel)
    func handleError(with error: APIErrorModel, closure: (() -> Void)?)
}

struct APIErrorModel: Error, Codable {
    var message: String

    init() {
        message = ""
    }
}
