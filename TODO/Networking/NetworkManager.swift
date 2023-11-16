//
//  NetworkManager.swift
//  TODO
//
//  Created by Jasim Uddin on 16/11/2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager() // Singleton instance
    
    private let baseUrl = "https://warp-wiry-rugby.glitch.me/todos"
    
    private init() {}
    
    func fetchData(completion: @escaping ([TodoElement]) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion([])
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([TodoElement].self, from: data)
                    completion(decodedData)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion([])
                }
            }
        }.resume()
    }
    
    func addTodo(newTodo: TodoElement, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(newTodo)
        } catch {
            print("Error encoding todo: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error adding todo: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
    
    func updateTodo(_ updatedTodo: TodoElement) {
        guard let url = URL(string: "\(baseUrl)/\(updatedTodo.id)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(updatedTodo)
        } catch {
            print("Error encoding updated todo: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating todo: \(error.localizedDescription)")
                return
            }
            // Handle success response or further processing if needed
        }.resume()
    }
    
    func sendDeleteRequest(todoID: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(todoID)") else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error deleting todo: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
