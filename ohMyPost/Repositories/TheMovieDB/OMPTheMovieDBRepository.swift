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
    func getPosts(byCategory: Int, callback: @escaping ([Post]) -> ()) {
        guard let category = MovieCategory(rawValue: byCategory) else {
            callback([])
            return
        }
        var api: TheMovieDBAPI
        switch category {
        case .popular:
            api = .popular
        case .upcoming:
            api = .upcoming
        case .topRated:
            api = .topRated
        }
        self.api.request(api) { result in
            switch result {
            case .success(let response):
                do {
                    let results: OMPMovieResponse = try JSONDecoder().decode(OMPMovieResponse.self, from: response.data)
                    return callback(results.results.map { $0.toPost(category: category) })
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
    
    func getPosts(callback: @escaping ([Post]) -> ()) {
        self.getPosts(byCategory: MovieCategory.popular.rawValue, callback: callback)
    }
}

extension OMPTheMovieDBRepository: PostDetailAPI {
    
    func getUser(userId: Int, callback: @escaping (User?) -> ()) {}
    
    func getComment(postId: Int, callback: @escaping ([Comment]) -> ()) {}
    
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
