import Foundation
import Alamofire

struct PersonService: NetworkService {

    var alamofireManager: Session
    var endpointConstructor: APIEndpointConstructor
    var dependencies: Dependencies

    public func login(completion: @escaping (_ json: ResponseJson?, _ error: APIErrorModel?) -> Void) {
        
        let url = endpointURL(endpointConstructor, endpoint: .login)
        performRequestWith(alamofireManager, httpMethod: .get, url: url, completion: { success, json, response in
            if success {
                if let object: Authentication = try? json.decode() {
                    self.dependencies.tokenManager.setApiKey(object.apiKey)
                }
                completion(json, nil)
            } else {
                completion(nil, self.error(with: json, and: response))
            }
        })
    }
    
    public func users(completion: @escaping (_ users: [UserModel], _ error: APIErrorModel?) -> Void) {
        let url = endpointURL(endpointConstructor, endpoint: .users)
        performRequestWith(alamofireManager, httpMethod: .get, url: url, parameters: nil, completion: { success, json, response in
            if success, let arrayJson = json["Array"], let jsonData = try? JSONSerialization.data(withJSONObject: arrayJson, options: []) {
                do {
                    let result = try JSONDecoder().decode([UserModel].self, from: jsonData)
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
