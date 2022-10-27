import UIKit

class APIEndpointConstructor: NSObject {
    private let baseUrl = "\(Environment().configuration(.webProtocol))://\(Environment().configuration(.baseServerUrl))" // "https://engineering.league.dev/challenge/api/"
    
    public enum EndpointType: Int {
        case
        login,
        users,
        posts
    }
    
    public func endpoint(endpoint: EndpointType) -> String? {
        switch endpoint {
        case .login:
            return baseUrl + "login"
        case .users:
            return baseUrl + "users"
        case .posts:
            return baseUrl + "posts"
        }
    }
}
