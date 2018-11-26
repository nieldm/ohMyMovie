import ohMyPostBase
import Foundation
import Moya

class OMPTheMovieDBRepository {
    let api: MoyaProvider<TheMovieDBAPI>
    
    init(mocked: Bool) {
        if mocked {
            self.api = MoyaProvider<TheMovieDBAPI>(stubClosure: MoyaProvider.immediatelyStub)
        } else {
            self.api = MoyaProvider<TheMovieDBAPI>()
        }
    }
}

extension OMPTheMovieDBRepository: PostAPI {
    func getPosts(callback: @escaping ([Post]) -> ()) {
        self.api.request(TheMovieDBAPI.list(1)) { result in
            switch result {
            case .success(let response):
                do {
                    let results: OMPMovieResponse = try JSONDecoder().decode(OMPMovieResponse.self, from: response.data)
                    return callback(results.results.map { $0.toPost() })
                } catch {
                    Current.log("error \(error.localizedDescription)")
                }

                callback([])
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
