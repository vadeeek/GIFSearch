import Foundation

struct Images: Decodable {
    let original: Original?

    enum CodingKeys: String, CodingKey {
        case original
    }
}
