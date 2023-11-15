
import Foundation

// MARK: - TodoElement
struct TodoElement: Codable, Equatable {
    let id: Int
    var title, priority: String
}

typealias Todo = [TodoElement]

