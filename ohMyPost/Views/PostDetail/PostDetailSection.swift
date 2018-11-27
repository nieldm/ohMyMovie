import Foundation
import ohMyPostBase

enum PostDetailSection {
    case resource(Resource)
    case user(User)
    case comments([Comment])
    case comment(Comment)
    
    var position: Int {
        switch self {
        case .resource(_): return 0
        case .user(_): return 1
        case .comments(_): return 2
        case .comment(_): return 3
        }
    }
}
