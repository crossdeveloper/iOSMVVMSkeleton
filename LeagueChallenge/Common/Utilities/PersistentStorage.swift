import Realm
import RealmSwift

final class PersistentStorage {

    var realm: Realm? {
        return try? Realm()
    }

    var inWriteTransaction: Bool{
        return realm?.isInWriteTransaction ?? false
    }
    
    static func configure() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }

    func refresh() {
        realm?.refresh()
    }

    func asyncWrite(operations: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            autoreleasepool {
                do {
                    try self?.realm?.write {
                        operations()
                    }
                } catch {
                    fatalError("Error during async write: \(error)")
                }
            }
        }
    }
}

// MARK: - Create

extension PersistentStorage {
    func create<T: Object>(_ data: T, update: Bool = true, completion: @escaping () -> Void) {
        asyncWrite { [weak self] in
            self?.preserveRelations(data, update: true)
            update ? self?.realm?.add(data, update: Realm.UpdatePolicy.all) : self?.realm?.add(data)
            completion()
        }
    }

    func create<T: Object>(_ data: [T], update: Bool = true, policy: Realm.UpdatePolicy = .all, completion: @escaping () -> Void) {
        asyncWrite { [weak self] in
            for object in data {
                self?.preserveRelations(object, update: true)
            }
            update ? self?.realm?.add(data, update: policy) : self?.realm?.add(data)
            completion()
        }
    }

    private func preserveRelations<T: Object>(_ data: T, update: Bool) {

        if let key = type(of: data).primaryKey(), let value = data[key], update {
            if let existingObject = read(type(of: data), key: value) {
                let relationships = existingObject.objectSchema.properties.filter {
                    $0.isArray
                }
                for relationship in relationships {
                    if data.dynamicList(relationship.name).count == 0 {
                        data[relationship.name] = existingObject[relationship.name]
                    }
                }
            }
        }
    }
}

// MARK: - Read

extension PersistentStorage {
    func read<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        return predicate == nil ? realm?.objects(type) : realm?.objects(type).filter(predicate!)
    }

    func read<T: Object>(_ type: T.Type, key: Any) -> T? {
        return realm?.object(ofType: type, forPrimaryKey: key)
    }
}

// MARK: - Update

extension PersistentStorage {
    func update(action: @escaping () -> Void, completion: @escaping () -> Void) {
        do {
            try realm?.write {
                action()
            }
        } catch {
            fatalError("Error during async write: \(error)")
        }
        completion()
    }
}

// MARK: - Delete

extension PersistentStorage {
    func delete<T: Object>(_ data: [T], completion: @escaping () -> Void) {
        do {
            try realm?.write {
                realm?.delete(data)
                completion()
            }
        } catch {
            fatalError("Error during async write: \(error)")
        }
    }

    func delete<T: Object>(_ data: T, completion: @escaping () -> Void) {
        delete([data]) {
            completion()
        }
    }

    func deleteAll(completion: @escaping () -> Void) {
        asyncWrite { [weak self] in
            self?.realm?.deleteAll()
            completion()
        }
    }
}
