import Foundation

public protocol PostAPI {
    func getPosts(callback: @escaping ([Post]) -> ())
    func getPosts(byCategory: Int, callback: @escaping ([Post]) -> ())
}
