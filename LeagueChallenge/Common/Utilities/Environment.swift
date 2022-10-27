import Foundation

public enum PlistKey {
    case baseServerUrl
    case webProtocol

    func value() -> String {
        switch self {
        case .baseServerUrl:
            return "baseServerUrl"
        case .webProtocol:
            return "webProtocol"
        }
    }
}

public struct Environment {

    fileprivate var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }

    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .baseServerUrl:
            return infoDict[PlistKey.baseServerUrl.value()] as? String ?? ""
        case .webProtocol:
            return infoDict[PlistKey.webProtocol.value()] as? String ?? ""
        }
    }
}
