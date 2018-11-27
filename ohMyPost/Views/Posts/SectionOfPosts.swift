import Foundation
import ohMyPostBase
import RxDataSources

struct SectionOfPosts {
    
    var header: String
    var items: [Item]
    
}

extension SectionOfPosts: AnimatableSectionModelType {
    
    typealias Item = Resource
    typealias Identity = String
    
    init(original: SectionOfPosts, items: [Item]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return self.header
    }
    
}

extension Resource: IdentifiableType {
    
    public typealias Identity = Int
    
    public var identity: Int {
        return self.id
    }
    
}
