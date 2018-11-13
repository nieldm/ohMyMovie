import XCTest
@testable import ohMyPost

class OMPGoogleDocsRepositoryTest: XCTestCase {

    var sut: OMPGoogleDocsRepository!
    
    override func setUp() {
        self.sut = OMPGoogleDocsRepository(mocked: true)
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
                XCTFail("No Posts")
                return
            }
            XCTAssertEqual(post.title, "title")
            XCTAssertEqual(post.body, "description")
            expectation.fulfill()
        }
    }

}
