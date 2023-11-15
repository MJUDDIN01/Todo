import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoElement] = []
    
    func addTodo(title: String, priority: String) {
        let newTodo = TodoElement(id: todos.count + 1, title: title, priority: priority)
        // Create and send a network request to add the todo to the server
        guard let url = URL(string: baseUrl) else {
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
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error adding todo: \(error.localizedDescription)")
                return
            }
            
            // If the network request is successful, update the local todos array
            DispatchQueue.main.async {
                self.todos.append(newTodo)
            }
        }.resume()
    }
    
    func fetchData() {
        let urlString = baseUrl
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(Todo.self, from: data)
                    DispatchQueue.main.async {
                        self.todos = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func deleteTodo(at index: Int) {
        guard index >= 0, index < todos.count else {
            return
        }
        
        let deletedTodo = todos[index]
        
        // Send a network request to delete the item from the server
        sendDeleteRequest(todoID: deletedTodo.id) { success in
            if success {
                // If the server deletion was successful, update the local todos array
                DispatchQueue.main.async {
                    self.todos.remove(at: index)
                }
            } else {
                // If the server deletion failed, consider handling the error
                print("Server deletion failed for todo ID: \(deletedTodo.id)")
            }
        }
    }
    
    // sending a DELETE request method
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
            // Assume success if no error occurred
            completion(true)
        }.resume()
    }
    
}

