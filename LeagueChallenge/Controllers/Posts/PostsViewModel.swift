import RealmSwift
import RxCocoa
import RxSwift
import RxRealm
import AVFoundation

class PostsViewModel: BaseViewModel {
    
    // MARK: - PRIVATE PROPERTIES
    fileprivate var users: Results<UserModel>?
    fileprivate var posts: Results<PostModel>?

    // MARK: - PUBLIC PROPERTIES
    let items = BehaviorRelay<[PostCellVM]>(value: [])
    
    // MARK: - PUBLIC METHODS
    override init(dependencies: Dependencies, errorDelegate: CanHandleError? = nil) {
        super.init(dependencies: dependencies, errorDelegate: errorDelegate)
        fetchUsers()
        fetchPosts()
        bindData()
    }
}

// MARK: - PRIVATE METHODS
private extension PostsViewModel{
    func bindData() {
        users = dependencies.dataManager.allUsersOffline()
        posts = dependencies.dataManager.allPostsOffline()        
        
        print(users)
        print(posts)
        bindPosts()
    }
    
    func fetchUsers() {
        dependencies.dataManager.getUsers { [weak self] _, error in
            if let error = error {
                self?.errorDelegate?.handleError(with: error)
            }
        }
    }
    
    func fetchPosts() {
        dependencies.dataManager.getPosts { [weak self] _, error in
            if let error = error {
                self?.errorDelegate?.handleError(with: error)
            }
        }
    }

    func bindPosts() {
        guard let users = users, let posts = posts else { return }
        Observable.combineLatest(Observable.collection(from: users), Observable.collection(from: posts)) { [weak self] _, postCollection -> [PostCellVM] in
            guard let self = self else {return []}

            return postCollection.toArray().map { [weak self] post -> PostCellVM in
                let user = self?.dependencies.dataManager.userOffline(with: post.userId)
                return PostCellVM(profileImage: user?.avatar, username: user?.name, title: post.title, content: post.body)
            }
        }.subscribe(onNext: { items in
            self.items.accept(items)
        }).disposed(by: disposeBag)
    }
}
