import ohMyPostBase
import Foundation

extension OMPRepository: PostDetailAPI {
    
    func getUser(userId: Int, callback: @escaping (User?) -> ()) {
        self.api.request(JSONPlaceholderAPI.user(id: userId)) { result in
            switch result {
            case .success(let response):
                let user: User? = try? JSONDecoder().decode(User.self, from: response.data)
                callback(user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getComment(postId: Int, callback: @escaping ([Comment]) -> ()) {
        self.api.request(JSONPlaceholderAPI.comments(postId: postId)) { result in
            switch result {
            case .success(let response):
                let comments: [Comment]? = try? JSONDecoder().decode(Array<Comment>.self, from: response.data)
                callback(comments ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}
