import UIKit

class Dependencies: NSObject {
    var networkManager: NetworkManager!
    var tokenManager: TokenManager!
    var loginManager: LogInManager!
    var dataManager: DataManager!
    var personService: PersonService!
    var postService: PostService!
}

protocol HasDependenciesProtocol {
    var dependencies: Dependencies { get set }
    init(dependencies: Dependencies)
}

class HasDependencies: NSObject, HasDependenciesProtocol {
    var dependencies: Dependencies

    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
}
