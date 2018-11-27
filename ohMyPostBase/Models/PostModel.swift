import Foundation

public class PostModel {
    private let api: PostAPI
    
    public init(api: PostAPI) {
        self.api = api
    }
    
    public func loadPosts(callback: @escaping ([Post]) -> Void) {
        self.api.getPosts(callback: callback)
    }
    
    public func loadPosts(byCategory: Int, callback: @escaping ([Post]) -> Void) {
        self.api.getPosts(byCategory: byCategory, callback: callback)
    }
}
