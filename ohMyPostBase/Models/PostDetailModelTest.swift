import XCTest
@testable import ohMyPostBase

class ResourceDetailModelTest: XCTestCase {

    var sut: ResourceDetailModel!
    
    override func setUp() {
        self.sut = ResourceDetailModel(
            api: MockedAPI(),
            resource: Resource(id: 0, userId: 0, title: "Test", body: "TestCase", image: nil)
        )
    }

    func test_user() {
        self.sut.getUser { user in
            XCTAssertEqual(user?.name, "Daniel Mendez")
        }
    }
    
    func test_comment() {
        self.sut.getComment { comments in
            XCTAssertEqual(comments.first?.email, "nieldm@gmail.com")
        }
    }

}

class MockedAPI {}

extension MockedAPI: ResourceDetailAPI {
    func getUser(userId: Int, callback: (User?) -> ()) {
        callback(User(
            id: 0,
            username: "nieldm",
            name: "Daniel Mendez",
            phone: "317000000",
            website: "nieldm.com",
            email: "nieldm@gmail.com"
        ))
    }
    
    func getComment(resourceId: Int, callback: @escaping ([Comment]) -> ()) {
        callback([Comment(id: 0, name: "nieldm", email: "nieldm@gmail.com", body: "Hello World")])
    }
}
