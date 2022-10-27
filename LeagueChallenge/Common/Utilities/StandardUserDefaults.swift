import Foundation
import KeychainSwift

final class StandardUserDefaults {
    static var username: String? {
        get {
            return string(forKey: .username)
        }
        set {
            set(newValue, forKey: .username)
        }
    }

    static var password: String? {
        get {
            return string(forKey: .password)
        }
        set {
            set(newValue, forKey: .password)
        }
    }

    static var apiKey: String? {
        get {
            return string(forKey: .apiKey)
        }
        set {
            set(newValue, forKey: .apiKey)
        }
    }

    static func clear(){
        _ = KeychainSwift().clear()
    }
}

private extension StandardUserDefaults {

    class func string(forKey key: Key) -> String? {
        return KeychainSwift().get(key.rawValue)
    }
    
    class func object<T: Codable>(forKey key: Key) -> T? {
        if let data = KeychainSwift().getData(key.rawValue),
           let object = try? JSONDecoder().decode(T.self, from: data) {
            return object
        }
        return nil
    }
    
    class func setObject<T: Codable>(object: T?, key: Key) {
        if let object = object, let data = try? JSONEncoder().encode(object) {
            KeychainSwift().set(data, forKey: key.rawValue)
        }
    }

    class func set(_ value: Any?, forKey key: Key) {
        if let value = value as? String{
            KeychainSwift().set(value, forKey: key.rawValue)
        }
    }
}

private enum Key: String {
    case username
    case password
    case apiKey
}
