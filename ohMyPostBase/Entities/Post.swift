import Foundation
import Then

public struct Post: Codable, Then {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String
    public var image: String? = nil
    public var favorited = false
    public var read = false
    public var category: Int
    
    public init(id: Int, userId: Int, title: String, body: String, image: String? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.image = image
        self.category = 0
    }
    
    public init(id: Int, userId: Int, title: String, body: String, category: Int, image: String? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.image = image
        self.category = category
    }
}

extension Post: Equatable {
    public static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id && lhs.read == rhs.read && lhs.favorited == rhs.favorited
    }
}
