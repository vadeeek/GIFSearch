import Foundation

struct Original: Decodable {
    let url: String?

    enum CodingKeys: String, CodingKey {
        case url
    }
}
