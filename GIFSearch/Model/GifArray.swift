import Foundation

struct GifArray: Decodable {
    let gifs: [Gif]?
    
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
}
