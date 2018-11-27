import XCTest
@testable import ohMyPostBase

class ResourceModelTest: XCTestCase {

    var sut: ResourceModel!
    
    override func setUp() {
        self.sut = ResourceModel(api: MockedAPI())
    }

    func test_loadResource() {
        let expectation = XCTestExpectation(description: "Load Resource")
        self.sut.loadResource { (resource) in
            XCTAssertGreaterThan(resource.count, 0)
            expectation.fulfill()
        }
    }
    
    func test_firstPost() {
        let expectation = XCTestExpectation(description: "Load Resource")
        self.sut.loadResource { (resources) in
            guard let resource = resources.first else {
                fatalError("No Posts")
            }
            XCTAssertEqual(resource.title, "Hello World!")
            XCTAssertEqual(resource.body, "I'm Batman")
            expectation.fulfill()
        }
    }

}

class MockedAPI {}

extension MockedAPI: ResourceAPI {
    func getResource(byCategory: Int, callback: @escaping ([Resource]) -> ()) {
        let resource = Resource(
            id: 0,
            userId: 0,
            title: "Hello World!",
            body: "I'm Batman",
            category: byCategory,
            image: nil
        )
        callback([resource])
    }
    
    func getResource(callback: @escaping ([Resource]) -> ()) {
        let resource = Resource(id: 0, userId: 0, title: "Hello World!", body: "I'm Batman", image: nil)
        callback([resource])
    }
}
