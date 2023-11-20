import Foundation

class NetworkManager {
    static let shared = NetworkManager() // Singleton instance
    
    private let baseUrl = "https://warp-wiry-rugby.glitch.me/todos"
    
    private init() {}
    
    func fetchData() async throws -> [TodoElement] {
        guard let url = URL(string: baseUrl) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode([TodoElement].self, from: data)
        return decodedData
    }
    
    func addTodo(newTodo: TodoElement) async throws -> Bool {
        guard let url = URL(string: baseUrl) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(newTodo)
        } catch {
            throw NetworkError.encodingError
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    func updateTodo(_ updatedTodo: TodoElement) async throws {
        guard let url = URL(string: "\(baseUrl)/\(updatedTodo.id)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(updatedTodo)
        } catch {
            throw NetworkError.encodingError
        }
        
        let (_, _) = try await URLSession.shared.data(for: request)
//        return (response as? HTTPURLResponse)?.statusCode == 200
        // Handle success response or further processing if needed
    }
    
    func deleteTodo(todoID: Int) async throws -> Bool {
        guard let url = URL(string: "\(baseUrl)/\(todoID)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
}
