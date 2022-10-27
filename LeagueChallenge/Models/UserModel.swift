import Foundation
import Realm
import RealmSwift

class UserModel: Object, Codable {

    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var website: String = ""

    @objc dynamic var avatar: String?
    @objc dynamic var address: AddressModel?
    @objc dynamic var company: CompanyModel?
    
    public override static func primaryKey() -> String? {
        return "id"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case email
        case phone
        case website
        case avatar
        case address
        case company
    }

    // MARK: - INITIALIZERS

    public required convenience init(from decoder: Decoder) throws {

        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = "\(try container.decode(Int.self, forKey: .id))"
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        website = try container.decodeIfPresent(String.self, forKey: .website) ?? ""
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        address = try container.decodeIfPresent(AddressModel.self, forKey: .address)
        company = try container.decodeIfPresent(CompanyModel.self, forKey: .company)
    }
    
    public convenience init(id: String, name: String) {
        self.init()
        
        self.id = id
        self.name = name
    }
}

class AvatarModel: Object, Codable {
    @objc dynamic var large: String = ""
    @objc dynamic var medium: String = ""
    @objc dynamic var thumbnail: String = ""

    override static func primaryKey() -> String? {
        return "thumbnail"
    }

    public required convenience init(from decoder: Decoder) throws {

        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        large = try container.decodeIfPresent(String.self, forKey: .large) ?? ""
        medium = try container.decodeIfPresent(String.self, forKey: .medium) ?? ""
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
    }
}

class AddressModel: Object, Codable {
    @objc dynamic var street: String = ""
    @objc dynamic var suite: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var zipcode: String = ""
    
    @objc dynamic var geo: GeoModel?

    override static func primaryKey() -> String? {
        return "zipcode"
    }

    public required convenience init(from decoder: Decoder) throws {

        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        street = try container.decodeIfPresent(String.self, forKey: .street) ?? ""
        suite = try container.decodeIfPresent(String.self, forKey: .suite) ?? ""
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        zipcode = try container.decodeIfPresent(String.self, forKey: .zipcode) ?? ""
        geo = try container.decodeIfPresent(GeoModel.self, forKey: .geo)
    }
}

class GeoModel: Object, Codable {
    @objc dynamic var lat: String = ""
    @objc dynamic var lng: String = ""

    override static func primaryKey() -> String? {
        return "lat"
    }

    public required convenience init(from decoder: Decoder) throws {

        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        lat = try container.decodeIfPresent(String.self, forKey: .lat) ?? ""
        lng = try container.decodeIfPresent(String.self, forKey: .lng) ?? ""
    }
}

class CompanyModel: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var catchPhrase: String = ""
    @objc dynamic var bs: String = ""

    override static func primaryKey() -> String? {
        return "name"
    }

    public required convenience init(from decoder: Decoder) throws {

        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        catchPhrase = try container.decodeIfPresent(String.self, forKey: .catchPhrase) ?? ""
        bs = try container.decodeIfPresent(String.self, forKey: .bs) ?? ""
    }
}
