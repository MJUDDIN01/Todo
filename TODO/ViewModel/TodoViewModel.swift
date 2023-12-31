import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoElement] = []
    private var lastUsedId: String = UUID().uuidString
    
    func fetchData() async {
        do {
            let fetchedTodos = try await NetworkManager.shared.fetchData()
            DispatchQueue.main.async {
                // Filter out existing todos from fetchedTodos
                let newTodos = fetchedTodos.filter { fetchedTodo in
                    !self.todos.contains(where: { $0.id == fetchedTodo.id })
                }
                // Append only new todos to the existing todos array
                self.todos += newTodos
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func addTodo(title: String, priority: String) async throws {
        lastUsedId += UUID().uuidString
        let newTodo = TodoElement(id: lastUsedId, title: title, priority: priority)
        do {
            let success = try await NetworkManager.shared.addTodo(newTodo: newTodo)
                    if success {
                        DispatchQueue.main.async {
                            // Check if the new todo already exists
                            if !self.todos.contains(where: { $0.id == newTodo.id }) {
                                self.todos.append(newTodo)
                            }
                        }
            }
        } catch {
            throw error
        }
    }
    
    func updateTodo(_ updatedTodo: TodoElement) async throws {
        do {
            try await NetworkManager.shared.updateTodo(updatedTodo)
                   DispatchQueue.main.async {
                       if let index = self.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                           self.todos[index] = updatedTodo
                       }
                   }
        } catch {
            throw error
        }
    }
    
    func deleteTodo(at index: Int) async {
        guard index >= 0, index < todos.count else {
            return
        }
        let deletedTodo = todos[index]
        do {
            let success = try await NetworkManager.shared.deleteTodo(todoID: deletedTodo.id)
            if success {
                DispatchQueue.main.async {
                    self.todos.remove(at: index)
                }
            } else {
                print("Server deletion failed for todo ID: \(deletedTodo.id)")
            }
        } catch {
            print("Error deleting todo: \(error)")
        }
    }
}
