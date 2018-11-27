import Foundation

public protocol ResourceDetailAPI {
    func getUser(userId: Int, callback: @escaping (User?) -> ())
    func getComment(resourceId: Int, callback: @escaping ([Comment]) -> ())
}
