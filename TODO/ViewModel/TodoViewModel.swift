import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoElement] = []
    
    func fetchData() {
        NetworkManager.shared.fetchData { [weak self] todos in
            DispatchQueue.main.async {
                self?.todos = todos
            }
        }
    }
    
    func addTodo(title: String, priority: String) {
        let newTodo = TodoElement(id: todos.count + 1, title: title, priority: priority)
        NetworkManager.shared.addTodo(newTodo: newTodo) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.todos.append(newTodo)
                }
            }
        }
    }
    
    func updateTodo(_ updatedTodo: TodoElement) {
        NetworkManager.shared.updateTodo(updatedTodo)
        DispatchQueue.main.async {
            if let index = self.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                self.todos[index] = updatedTodo
            }
        }
    }
    
    func deleteTodo(at index: Int) {
        guard index >= 0, index < todos.count else {
            return
        }
        let deletedTodo = todos[index]
        NetworkManager.shared.sendDeleteRequest(todoID: deletedTodo.id) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.todos.remove(at: index)
                }
            } else {
                print("Server deletion failed for todo ID: \(deletedTodo.id)")
            }
        }
    }
}
