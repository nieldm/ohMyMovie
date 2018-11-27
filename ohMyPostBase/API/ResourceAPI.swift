import Foundation

public protocol ResourceAPI {
    func getResource(callback: @escaping ([Resource]) -> ())
    func getResource(byCategory: Int, callback: @escaping ([Resource]) -> ())
}
