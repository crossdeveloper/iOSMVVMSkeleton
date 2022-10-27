import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func localized(default dflt: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: dflt, comment: "")
    }
}
