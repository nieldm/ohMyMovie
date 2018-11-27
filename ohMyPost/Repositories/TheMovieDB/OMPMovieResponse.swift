import Foundation

struct OMPMovieResponse: Codable {
    
    var id: Int?
    var results: [OMPMovie]
    var totalResult: Int
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case results
        case totalResult = "total_results"
    }
    
}
