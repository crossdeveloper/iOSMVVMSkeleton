import Alamofire

struct Authentication: Codable {
    var apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
