import Alamofire
import Foundation

struct PostService: NetworkService {
    
    var alamofireManager: Session
    var endpointConstructor: APIEndpointConstructor
    var dependencies: Dependencies

    // MARK: - Fetching posts
    
    public func posts(with userId: Int? = nil, completion: @escaping (_ result: [PostModel], _ error: APIErrorModel?) -> Void) {
        var params: [String] = []
        if let userId = userId {
            params.append("userId=\(userId)")
        }
        
        let url = endpointURL(endpointConstructor, endpoint: .posts, params: params)
        performRequestWith(alamofireManager, httpMethod: .get, url: url, completion: { success, json, response in
            if success, let arrayJson = json["Array"], let jsonData = try? JSONSerialization.data(withJSONObject: arrayJson, options: []) {
                do {
                    let result = try JSONDecoder().decode([PostModel].self, from: jsonData)
                    completion(result, nil)
                } catch {
                    print(error)
                }
            } else {
                completion([], self.error(with: json, and: response))
            }
        })
    }
}
