import Foundation

public class ResourceModel {
    private let api: ResourceAPI
    
    public init(api: ResourceAPI) {
        self.api = api
    }
    
    public func loadResource(callback: @escaping ([Resource]) -> Void) {
        self.api.getResource(callback: callback)
    }
    
    public func loadResource(byCategory: Int, callback: @escaping ([Resource]) -> Void) {
        self.api.getResource(byCategory: byCategory, callback: callback)
    }
}
