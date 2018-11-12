import ohMyPostBase
import Foundation

extension OMPGoogleDocsRepository: PostDetailAPI {
    
    func getUser(userId: Int, callback: @escaping (User?) -> ()) {
        callback(nil)
    }
    
    func getComment(postId: Int, callback: @escaping ([Comment]) -> ()) {
        callback([])
    }
    
    
}
