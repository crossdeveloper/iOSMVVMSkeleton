import Alamofire
import RealmSwift
import UIKit
import SwiftUI

protocol DataManagerProtocol {}

class DataManager: HasDependencies, DataManagerProtocol {

    let truePredicate = "TRUEPREDICATE"
    let persistentStorage = PersistentStorage()

    func deleteAll(completion: (() -> Void)? = nil) {
        persistentStorage.deleteAll {
            completion?()
        }
    }

    func save(completion: @escaping () -> Void) {
        persistentStorage.asyncWrite {
            completion()
        }
    }

    func update(action: @escaping () -> Void, completion: (() -> Void)? = nil) {
        persistentStorage.update(action: {
            action()
        }, completion: {
            completion?()
        })
    } 
}

extension DataManager {
    func getUsers(completion: @escaping (_ users: [UserModel], _ error: APIErrorModel?) -> Void) {
        if NetworkManager.isNetworkConnectionAvailable() {
            dependencies.personService.users { [weak self] users, error in
                guard let self = self else { return }
                if let error = error {
                    completion([], error)
                } else {
                    self.createUsers(with: users) {
                        completion(users, nil)
                    }
                }
            }
        } else {
            completion([], dependencies.personService.networkError())
        }
    }
    
    func getPosts(completion: @escaping (_ posts: [PostModel], _ error: APIErrorModel?) -> Void) {
        if NetworkManager.isNetworkConnectionAvailable() {
            dependencies.postService.posts { [weak self] posts, error in
                guard let self = self else { return }
                if let error = error {
                    completion([], error)
                } else {
                    self.createPosts(with: posts) {
                        completion(posts, nil)
                    }
                }
            }
        } else {
            completion([], dependencies.personService.networkError())
        }
    }
}

extension DataManager {    
    func allUsersOffline() -> Results<UserModel>? {
        return persistentStorage.read(UserModel.self)
    }
    
    func allPostsOffline() -> Results<PostModel>? {
        return persistentStorage.read(PostModel.self)
    }
    
    func createUsers(with users: [UserModel], completion: (() -> Void)? = nil) {
        self.persistentStorage.create(users, update: true) {
            DispatchQueue.main.async { [weak self] in
                self?.persistentStorage.refresh()
                completion?()
            }
        }
    }
    
    func createPosts(with posts: [PostModel], completion: (() -> Void)? = nil) {
        self.persistentStorage.create(posts, update: true) {
            DispatchQueue.main.async { [weak self] in
                self?.persistentStorage.refresh()
                completion?()
            }
        }
    }
    
    func userOffline(with id: String) -> UserModel? {
        let predicate = NSPredicate(format: "id = %@", id)
        if let user = persistentStorage.read(UserModel.self, predicate: predicate)?.first {
            return user
        }
        return nil
    }
}
