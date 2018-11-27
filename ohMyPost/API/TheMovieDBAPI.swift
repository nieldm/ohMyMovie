import Moya
import Foundation
import ohMyPostBase

enum TheMovieDBAPI {
    case list(Int)
    case popular
    case topRated
    case upcoming
}

extension TheMovieDBAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var path: String {
        switch self {
        case .list(let id):
            return "/4/list/\(id)"
        case .popular:
            return "/3/movie/popular"
        case .topRated:
            return "/3/movie/top_rated"
        case .upcoming:
            return "/3/movie/upcoming"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
//        case .list(_):
        default:
            guard let
                path = Bundle.main.path(forResource: "postResponse", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        switch self {
        case .list(_):
            return .requestPlain
        default:
            return .requestParameters(
                parameters: ["api_key": "5bce4abdd86b37c1accefc7dc9b8e836"],
                encoding: URLEncoding.queryString
            )
        }
        
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        switch self {
        case .list(_):
            headers["Content-Type"] = "application/json;charset=utf-8"
            headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YmNlNGFiZGQ4NmIzN2MxYWNjZWZjN2RjOWI4ZTgzNiIsInN1YiI6IjViZjViY2NiMGUwYTI2NGY2ZTA1NjlkYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.G5irh5h00Lk7NP7J-OGO5mz0GxBcfnQk6wovbhj_sFw"
        default: ()
        }
        return headers
    }
    
}
