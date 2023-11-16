import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoElement] = []
    
    func fetchData() async {
        do {
            let fetchedTodos = try await NetworkManager.shared.fetchData()
            DispatchQueue.main.async {
                self.todos = fetchedTodos
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func addTodo(title: String, priority: String) async {
        let newTodo = TodoElement(id: todos.count + 1, title: title, priority: priority)
        do {
            let success = try await NetworkManager.shared.addTodo(newTodo: newTodo)
            if success {
                DispatchQueue.main.async {
                    self.todos.append(newTodo)
                }
            }
        } catch {
            print("Error adding todo: \(error)")
        }
    }
    
    func updateTodo(_ updatedTodo: TodoElement) async {
        do {
            try await NetworkManager.shared.updateTodo(updatedTodo)
            DispatchQueue.main.async {
                if let index = self.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                    self.todos[index] = updatedTodo
                }
            }
        } catch {
            print("Error updating todo: \(error)")
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
