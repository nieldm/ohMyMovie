import XCTest
@testable import ohMyPost

class OMPTheMovieDBRepositoryTest: XCTestCase {
    
    var sut: OMPTheMovieDBRepository!
    
    override func setUp() {
        self.sut = OMPTheMovieDBRepository(mocked: false)
    }
    
    func test_getPosts() {
        let expectation = XCTestExpectation(description: "response")
        self.sut.getPosts { (posts) in
            XCTAssertGreaterThan(posts.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func test_firstPost() {
        let expectation = XCTestExpectation(description: "Load Posts")
        self.sut.getPosts { (posts) in
            guard let post = posts.first else {
                XCTFail("No Posts")
                return
            }
            XCTAssertEqual(post.title, "Thor: Ragnarok")
            XCTAssertEqual(post.body, "Thor is on the other side of the universe and finds himself in a race against time to get back to Asgard to stop Ragnarok, the prophecy of destruction to his homeworld and the end of Asgardian civilization, at the hands of an all-powerful new threat, the ruthless Hela.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
}
