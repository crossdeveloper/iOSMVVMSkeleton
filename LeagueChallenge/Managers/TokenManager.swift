import Foundation

class TokenManager: HasDependencies {
    @discardableResult func setApiKey(_ key: String) -> Bool {
        StandardUserDefaults.apiKey = key
        return true
    }
    
    func getApiKey() -> String? {
        return StandardUserDefaults.apiKey
    }
}
