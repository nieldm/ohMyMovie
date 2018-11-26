import Foundation
import ohMyPostBase

struct OMPMovie: Codable {
    
    var id: Int
    var posterPath: String
    var overview: String
    var title: String
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case posterPath = "poster_path"
        case overview
        case title
        case releaseDate = "release_date"
    }
    
    func toPost() -> Post {
        let imageUrl = "https://image.tmdb.org/t/p/w500\(self.posterPath)"
        return Post(id: self.id, userId: 0, title: self.title, body: self.overview, image: imageUrl)
    }
    
}
