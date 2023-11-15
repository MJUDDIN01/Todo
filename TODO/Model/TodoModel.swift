
import Foundation

// MARK: - TodoElement
struct TodoElement: Codable, Equatable {
    let id: Int
    let title, priority: String
}

typealias Todo = [TodoElement]

