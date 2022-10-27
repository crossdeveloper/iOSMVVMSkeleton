import Foundation
import Realm
import RealmSwift

class PostModel: Object, Codable {
    
    @objc dynamic var id: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case body
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - INIT
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = "\(try container.decode(Int.self, forKey: .id))"
        
        userId = "\(try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0)"
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        body = try container.decodeIfPresent(String.self, forKey: .body) ?? ""
    }
    
    public convenience init(id: String, userId: String, title: String, body: String) {
        self.init()
        
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
