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

extension OMPTheMovieDBRepository: ResourceAPI {
    
    func getResource(byCategory: Int, callback: @escaping ([Resource]) -> ()) {
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
                    return callback(results.results.map { $0.toResource(category: category) })
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
    
    func getResource(callback: @escaping ([Resource]) -> ()) {
        self.getResource(byCategory: MovieCategory.popular.rawValue, callback: callback)
    }
}

extension OMPTheMovieDBRepository: ResourceDetailAPI {
    
    func getUser(userId: Int, callback: @escaping (User?) -> ()) {}
    
    func getComment(resourceId: Int, callback: @escaping ([Comment]) -> ()) {}
    
}


private extension Resource {
    static func create(fromData data: [String], withId id: Int) -> Resource {
        return Resource(
            id: id,
            userId: 0,
            title: data[0],
            body: data[1],
            image: data[2]
        )
    }
}
