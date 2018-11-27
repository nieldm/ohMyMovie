import XCTest
@testable import ohMyPost

class OMPTheMovieDBRepositoryTest: XCTestCase {
    
    var sut: OMPTheMovieDBRepository!
    
    override func setUp() {
        self.sut = OMPTheMovieDBRepository(mocked: true)
    }
    
    func test_getResource() {
        let expectation = XCTestExpectation(description: "response")
        self.sut.getResource { (posts) in
            XCTAssertGreaterThan(posts.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func test_firstResource() {
        let expectation = XCTestExpectation(description: "Load Posts")
        self.sut.getResource { (resources) in
            guard let resource = resources.first else {
                XCTFail("No Posts")
                return
            }
            XCTAssertEqual(resource.title, "Bohemian Rhapsody")
            XCTAssertGreaterThan(resource.body.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
}
