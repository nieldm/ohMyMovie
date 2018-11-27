import Foundation

public class ResourceDetailModel {
    private let api: ResourceDetailAPI
    public let resource: Resource
    
    public init(api: ResourceDetailAPI, resource: Resource) {
        self.api = api
        self.resource = resource
    }
    
    public func getUser(callback: @escaping (User?) -> ()) {
        self.api.getUser(userId: self.resource.userId, callback: callback)
    }
    
    public func getComment(callback: @escaping ([Comment]) -> ()) {
        self.api.getComment(resourceId: self.resource.id, callback: callback)
    }
    
}
