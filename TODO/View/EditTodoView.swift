
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
                TextField("Priority", text: $editedTodo.priority)
                    .padding()
                Button("Save") {
                    // Update the todo on the server
                    viewModel.updateTodo(editedTodo)
                    // Call the completion handler
                    onEditingComplete()
                }
                .padding()
            }
            .padding()
            .navigationTitle("Edit Todo")
        }
    }
}
