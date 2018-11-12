import Moya
import Foundation

enum GoogleDocsAPI {
    case posts
}

extension GoogleDocsAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://docs.google.com")!
    }
    
    var path: String {
        switch self {
        case .posts:
            return "/spreadsheet/ccc"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .posts:
            guard let
                path = Bundle.main.path(forResource: "testApplicationData", ofType: "csv"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        var parameters = [String: Any]()
        switch self {
        case .posts:
            parameters["single"] = "true"
            parameters["gid"] = "0"
            parameters["output"] = "csv"
        }
        parameters["key"] = "0Aqg9JQbnOwBwdEZFN2JKeldGZGFzUWVrNDBsczZxLUE"
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
