
import SwiftUI

struct EditTodoView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var editedTodo: TodoElement
    var onEditingComplete: () -> Void
    
    init(viewModel: TodoListViewModel, todo: TodoElement, onEditingComplete: @escaping () -> Void) {
        self.viewModel = viewModel
        self._editedTodo = State(initialValue: todo)
        self.onEditingComplete = onEditingComplete
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $editedTodo.title)
                    .padding()
                    .border(Color.gray)
                TextField("Priority", text: $editedTodo.priority)
                    .padding()
                    .border(Color.gray)
                Button("Save") {
                    Task {
                        await updateTodo()
                    }
                }
                .padding()
                .background(.brown)
                .foregroundColor(Color.white)
            }
            .padding()
            .navigationTitle("Edit Todo")
        }
    }
    
    func updateTodo() async {
        do {
            try await viewModel.updateTodo(editedTodo)
            onEditingComplete()
        } catch {
            print("Error updating todo: \(error)")
            // This catch block is not currently reachable but kept for potential future changes
        }
    }
}
