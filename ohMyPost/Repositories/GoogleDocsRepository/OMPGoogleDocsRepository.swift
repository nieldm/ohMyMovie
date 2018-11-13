import ohMyPostBase
import Foundation
import Moya
import CSV

class OMPGoogleDocsRepository {
    let api: MoyaProvider<GoogleDocsAPI>
    
    init(mocked: Bool) {
        if mocked {
            self.api = MoyaProvider<GoogleDocsAPI>(stubClosure: MoyaProvider.immediatelyStub)
        } else {
            self.api = MoyaProvider<GoogleDocsAPI>()
        }
    }
}

extension OMPGoogleDocsRepository: PostAPI {
    func getPosts(callback: @escaping ([Post]) -> ()) {
        self.api.request(GoogleDocsAPI.posts) { result in
            switch result {
            case .success(let response):
                let input = InputStream(data: response.data)
                guard let csv = try? CSVReader(stream: input) else {
                    Current.log("Error reading CSV")
                    return callback([])
                }
                var posts: [Post] = []
                var postId = 1
                while let row = csv.next() {
                    posts.append(Post.create(fromData: row, withId: postId))
                    postId+=1
                }
                callback(posts)
            case .failure(let error):
                Current.log(error.localizedDescription)
                callback([])
            }
        }
    }
}

private extension Post {
    static func create(fromData data: [String], withId id: Int) -> Post {
        return Post(
            id: id,
            userId: 0,
            title: data[0],
            body: data[1],
            image: data[2]
        )
    }
}
