import Moya
import Foundation
import ohMyPostBase

enum TheMovieDBAPI {
    case list(Int)
}

extension TheMovieDBAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/4")!
    }
    
    var path: String {
        switch self {
        case .list(let id):
            return "/list/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .list(_):
            guard let
                path = Bundle.main.path(forResource: "postResponse", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YmNlNGFiZGQ4NmIzN2MxYWNjZWZjN2RjOWI4ZTgzNiIsInN1YiI6IjViZjViY2NiMGUwYTI2NGY2ZTA1NjlkYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.G5irh5h00Lk7NP7J-OGO5mz0GxBcfnQk6wovbhj_sFw"]
    }
    
}
