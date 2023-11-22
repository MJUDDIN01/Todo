
import Foundation

// MARK: - TodoElement
struct TodoElement: Codable, Equatable {
    var id, title, priority: String
}

typealias Todo = [TodoElement]

