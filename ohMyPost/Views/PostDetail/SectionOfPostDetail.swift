import Foundation
import ohMyPostBase
import RxDataSources

struct SectionOfPostDetail {
    var header: String
    var items: [Item]
}

extension SectionOfPostDetail: AnimatableSectionModelType {
    
    typealias Item = PostDetailSection
    typealias Identity = String
    
    init(original: SectionOfPostDetail, items: [Item]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return self.header
    }
    
}

extension PostDetailSection: Equatable {
    
    static func == (lhs: PostDetailSection, rhs: PostDetailSection) -> Bool {
        return lhs.identity == rhs.identity
    }
    
}

extension PostDetailSection: IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .resource(let resource):
            return "Post\(resource.id)\(resource.category)"
        case .user(let user):
            return "User\(user.id)"
        case .comments(let comments):
            return "Comments\(comments.count)\(comments.first?.id ?? 0)"
        case .comment(let comment):
            return "Comment\(comment.id)"
        }
    }
}
