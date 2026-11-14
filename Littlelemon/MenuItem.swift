
import Foundation

struct MenuItem: Codable {
    let id: Int
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String
}

struct MenuResponse: Codable {
    let menu: [MenuItem]
}

