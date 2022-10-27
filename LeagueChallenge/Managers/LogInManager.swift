import UIKit

class LogInManager: HasDependencies {
    
    public func beginLogin(_ username: String? = nil, password: String? = nil, completion: @escaping (_ success: Bool, _ error: APIErrorModel?) -> Void) {
        dependencies.personService.login { [weak self] json, error in
            if let error = error {
                completion(false, error)
            } else if let object: Authentication = try? json?.decode() {
                self?.dependencies.tokenManager.setApiKey(object.apiKey)
                completion(true, nil)
            }
        }
    }
}
