//
//  TodoModel.swift
//  TODO
//
//  Created by Jasim Uddin on 14/11/2023.
//

import Foundation

// MARK: - TodoElement
struct TodoElement: Codable {
    let id: Int
    let title, priority: String
}

typealias Todo = [TodoElement]

