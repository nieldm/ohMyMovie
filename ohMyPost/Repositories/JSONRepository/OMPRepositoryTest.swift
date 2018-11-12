import XCTest
@testable import ohMyPost

class OMPRepositoryTest: XCTestCase {

    var sut: OMPRepository!
    
    override func setUp() {
        self.sut = OMPRepository(mocked: true)
    }

    func test_getPosts() {
        let expectation = XCTestExpectation(description: "response")
        self.sut.getPosts { (posts) in
            XCTAssertGreaterThan(posts.count, 0)
            expectation.fulfill()
        }
    }
    
    func test_firstPost() {
        let expectation = XCTestExpectation(description: "Load Posts")
        self.sut.getPosts { (posts) in
            guard let post = posts.first else {
                fatalError("No Posts")
            }
            XCTAssertEqual(post.title, "Oh My Posts!")
            XCTAssertEqual(post.body, "This app is Awesome!")
            expectation.fulfill()
        }
    }

}
