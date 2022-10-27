import Alamofire
import Foundation

struct NetworkManagerKeys {
    static let authorization = "Authorization"
}

class NetworkManager: HasDependencies {

    var baseURL: String?
    var sessionConfiguration: URLSessionConfiguration = .default

    // deafault Headers configuration, placeholder for now, but should be needed in the future
    var defaultHeaders: HTTPHeaders {
        let defaultHeaders = Session.default.sessionConfiguration.headers
        return defaultHeaders
    }

    // add access token to the default header for our requests

    public func createAlamofireConfiguration() -> Session {
        sessionConfiguration.httpAdditionalHeaders = defaultHeaders.dictionary
        sessionConfiguration.timeoutIntervalForRequest = 10
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfiguration.urlCache = nil
        
        let interceptor = NetworkIntercepter(dependencies: dependencies)
        return Session(configuration: sessionConfiguration, interceptor: interceptor, serverTrustManager: nil)
    }

    // basic network check, if we ever need it
    public static func isNetworkConnectionAvailable() -> Bool {
        guard let reachabilityManager = NetworkReachabilityManager(host: "\(Environment().configuration(PlistKey.baseServerUrl))") else {
            return false
        }
        return reachabilityManager.isReachable
    }
}
