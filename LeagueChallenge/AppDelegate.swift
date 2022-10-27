import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: PUBLIC PROPERTIES
    var window: UIWindow?
    
    // MARK: PRIVATE PROPERTIES
    let dependencies = Dependencies()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        buildDependencies()

        UIImageView.prepareImagesCache()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    func setRoot(vc: BaseViewController) {
        let nav = UINavigationController(rootViewController: vc)
        vc.dependencies = self.dependencies
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setRootFromScence(vc: BaseViewController, window: UIWindow?) {
        let nav = UINavigationController(rootViewController: vc)
        vc.dependencies = self.dependencies
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    private func buildDependencies() {
        let networkManager = NetworkManager(dependencies: dependencies)
        dependencies.networkManager = networkManager
        
        let alamofireManager = networkManager.createAlamofireConfiguration()
        let endpointConstructor = APIEndpointConstructor()

        dependencies.personService = PersonService(alamofireManager: alamofireManager, endpointConstructor: endpointConstructor, dependencies: dependencies)
        dependencies.postService = PostService(alamofireManager: alamofireManager, endpointConstructor: endpointConstructor, dependencies: dependencies)
        dependencies.loginManager = LogInManager(dependencies: dependencies)
        dependencies.tokenManager = TokenManager(dependencies: dependencies)
        dependencies.dataManager = DataManager(dependencies: dependencies)
    }
}
