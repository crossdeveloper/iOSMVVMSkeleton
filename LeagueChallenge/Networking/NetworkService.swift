import Alamofire
import Foundation

public typealias ResponseArray = [AnyObject]
public typealias ResponseJson = [String: AnyObject]
public typealias NetworkBasicClosure = (_ error: Error?, _ result: ResponseJson?) -> Void
public typealias NetworkResponseClosure = (_ success: Bool, _ responseJson: ResponseJson, _ response: HTTPURLResponse?) -> Void

protocol NetworkService {
    var alamofireManager: Session { get set }
    var endpointConstructor: APIEndpointConstructor { get set }
    var dependencies: Dependencies { get }
}

extension NetworkService {

    public mutating func updateAlamofireConfiguration(_ session: Session) {
        alamofireManager = session
    }

    public func endpointURL(_ endpointConstructor: APIEndpointConstructor, endpoint: APIEndpointConstructor.EndpointType, params: [String]? = nil) -> String {
        if let params = params {
            var url = endpointConstructor.endpoint(endpoint: endpoint) ?? ""
            url.append("?")
            for param in params {
                url.append("\(param)&")
            }
            url.removeLast()
            return url
        }
        return endpointConstructor.endpoint(endpoint: endpoint) ?? ""
    }

    func error(with json: ResponseJson, and response: HTTPURLResponse?) -> APIErrorModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            do {
                let error = try JSONDecoder().decode(APIErrorModel.self, from: jsonData)
                return error
            } catch {
            }
        }
        return nil
    }

    func error(with error: Error?) -> APIErrorModel? {
        var apiError = APIErrorModel()
        apiError.message = error?.localizedDescription ?? "network_issue".localized
        return apiError
    }
    
    func networkError() -> APIErrorModel? {
        var apiError = APIErrorModel()
        apiError.message = "network_issue".localized
        return apiError
    }

    func performRequestWith(_ alamofireManager: Session,
                            httpMethod: Alamofire.HTTPMethod,
                            url: String, encoding: ParameterEncoding = JSONEncoding.default,
                            parameters: [String: Any]? = nil,
                            headers: HTTPHeaders? = nil,
                            completion: @escaping NetworkResponseClosure) {
        
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        alamofireManager.request(encodedUrl, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .response(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    evaluateResponse(data, response: response.response, completion: completion)
                case .failure(let error):
                    evaluateErrorResponse(response.data, response: response.response, error: error, completion: completion)
                }
            })
    }
    
    
    func evaluateResponse(_ data: Data?, response: HTTPURLResponse?, completion: @escaping NetworkResponseClosure) {
        if let data = data {
            let value = try? JSONSerialization.jsonObject(with: data, options: [])
            if let array = value as? ResponseArray {
                let json: ResponseJson = ["Array": array as AnyObject]
                completion(true, json, response)
            } else if let json = value as? ResponseJson {
                completion(true, json, response)
            } else if let jsonArray = value as? [ResponseJson] {
                let json: ResponseJson = ["Array": jsonArray as AnyObject]
                completion(true, json, response)
            } else {
                completion(true, [:], response)
            }
        } else {
            completion(true, [:], response)
        }
    }
    
    func evaluateErrorResponse(_ data: Data?, response: HTTPURLResponse?, error: Error, completion: @escaping NetworkResponseClosure) {
        
        var responseJson: ResponseJson = [:]
        if let data = data, let apiError = try? JSONDecoder().decode(APIErrorModel.self, from: data) {
            responseJson["message"] = apiError.message as NSString
        } else {
            responseJson["message"] = error.localizedDescription as NSString
        }
        completion(false, responseJson, response)
    }
}
