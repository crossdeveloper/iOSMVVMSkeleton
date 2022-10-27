import XCTest
@testable import LeagueChallenge

private let mockPosts = [PostModel(id: "1", userId: "1", title: "Title1", body: "Body1"),
                         PostModel(id: "2", userId: "1", title: "Title2", body: "Body2"),
                         PostModel(id: "3", userId: "2", title: "Title3", body: "Body3"),
                         PostModel(id: "4", userId: "3", title: "Title4", body: "Body4")]

private let mockUsers = [UserModel(id: "1", name: "name1"),
                         UserModel(id: "2", name: "name2"),
                         UserModel(id: "3", name: "name3")]

class LeagueChallengeTests: XCTestCase {
    let dependencies = Dependencies()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataOffline() throws {
        let dataManager = dependencies.dataManager
        
        let deleteExpectation = expectation(description: "delete")
        let postsExpectation = expectation(description: "createPosts")
        let usersExpectation = expectation(description: "createUsers")
        
        dataManager?.deleteAll() {
            deleteExpectation.fulfill()
            XCTAssertEqual(dataManager?.allUsersOffline()?.count, 0)
            XCTAssertEqual(dataManager?.allPostsOffline()?.count, 0)
            dataManager?.createUsers(with: mockUsers) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    usersExpectation.fulfill()
                    XCTAssertEqual(dataManager?.allUsersOffline()?.count, 3)
                    dataManager?.createPosts(with: mockPosts) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            postsExpectation.fulfill()
                            XCTAssertEqual(dataManager?.allPostsOffline()?.count, 4)
                            XCTAssertEqual(dataManager?.userOffline(with: "1")?.name, "name1")
                            XCTAssertEqual(dataManager?.userOffline(with: "2")?.name, "name2")
                            XCTAssertEqual(dataManager?.userOffline(with: "3")?.name, "name3")
                        }
                    }
                }
            }
        }
        
        wait(for: [deleteExpectation, postsExpectation, usersExpectation], timeout: 10)
    }
    
    func testLogin() throws {
        StandardUserDefaults.clear()
        XCTAssertNil(dependencies.tokenManager.getApiKey())
        let loginExpectation = expectation(description: "login")
        
        dependencies.loginManager.beginLogin { [weak self] success, error in
            loginExpectation.fulfill()
            if success {
                XCTAssertNil(error)
                XCTAssertNotNil(self?.dependencies.tokenManager.getApiKey())
            } else {
                XCTAssertNotNil(error)
                XCTAssertNil(self?.dependencies.tokenManager.getApiKey())
            }
        }

        wait(for: [loginExpectation], timeout: 10)
    }
    
    func testGetUsers() throws {
        dependencies.tokenManager.setApiKey("5ECDDC3A21CE53428227A2125B7FCC71")
        let usersExpectation = expectation(description: "getUsers")
        
        dependencies.dataManager.getUsers { users, error in
            usersExpectation.fulfill()
            if users.isEmpty {
                XCTAssertNotNil(error)
                XCTAssertEqual(users.count, 0)
            } else {
                XCTAssertNil(error)
                XCTAssertGreaterThan(users.count, 0)
            }
        }

        wait(for: [usersExpectation], timeout: 10)
    }
    
    func testGetPosts() throws {
        dependencies.tokenManager.setApiKey("5ECDDC3A21CE53428227A2125B7FCC71")
        let postsExpectation = expectation(description: "getPosts")
        
        dependencies.dataManager.getPosts { posts, error in
            postsExpectation.fulfill()
            if posts.isEmpty {
                XCTAssertNotNil(error)
                XCTAssertEqual(posts.count, 0)
            } else {
                XCTAssertNil(error)
                XCTAssertGreaterThan(posts.count, 0)
            }
        }

        wait(for: [postsExpectation], timeout: 10)
    }
}
