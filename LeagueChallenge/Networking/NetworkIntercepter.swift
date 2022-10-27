import Foundation
import Alamofire

final class NetworkIntercepter: Alamofire.RequestInterceptor {
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
                
        if let apiKey = dependencies.tokenManager.getApiKey() {
            urlRequest.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        }

        completion(.success(urlRequest))
    }
}
