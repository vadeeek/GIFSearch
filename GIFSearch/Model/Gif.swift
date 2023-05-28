import Foundation

struct Gif: Decodable {
    let images: Images?

    enum CodingKeys: String, CodingKey {
        case images
    }
    
    func getGifURL() -> String {
        return images?.original?.url ?? ""
    }
}
