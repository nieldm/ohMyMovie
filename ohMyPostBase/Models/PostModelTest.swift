import XCTest
@testable import ohMyPostBase

class PostModelTest: XCTestCase {

    var sut: PostModel!
    
    override func setUp() {
        self.sut = PostModel(api: MockedAPI())
    }

    func test_loadPosts() {
        let expectation = XCTestExpectation(description: "Load Posts")
        self.sut.loadPosts { (posts) in
            XCTAssertGreaterThan(posts.count, 0)
            expectation.fulfill()
        }
    }
    
    func test_firstPost() {
        let expectation = XCTestExpectation(description: "Load Posts")
        self.sut.loadPosts { (posts) in
            guard let post = posts.first else {
                fatalError("No Posts")
            }
            XCTAssertEqual(post.title, "Hello World!")
            XCTAssertEqual(post.body, "I'm Batman")
            expectation.fulfill()
        }
    }

}

class MockedAPI {}

extension MockedAPI: PostAPI {
    func getPosts(callback: @escaping ([Post]) -> ()) {
        let post = Post(id: 0, userId: 0, title: "Hello World!", body: "I'm Batman", image: nil)
        callback([post])
    }
}
