
import SwiftUI

struct EditTodoView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var editedTodo: TodoElement
    private var originalTodo: TodoElement
    private var onEditingComplete: () -> Void
    
    init(viewModel: TodoListViewModel, todo: TodoElement, onEditingComplete: @escaping () -> Void) {
        self.viewModel = viewModel
        self.originalTodo = todo
        self._editedTodo = State(initialValue: todo)
        self.onEditingComplete = onEditingComplete
    }
    
    @State private var showAlert = false

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
                        await saveChanges()
                    }
                }
                .padding()
                .background(.brown)
                .foregroundColor(Color.white)
                .cornerRadius(8)
            }
            .padding()
            .navigationTitle("Edit Todo")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("No changes made"),
                    message: Text("Nothing has changed."),
                    dismissButton: .default(Text("Change Now"))
                )
            }
        }
    }
    
    private func saveChanges() async {
        if editedTodo == originalTodo {
            showAlert = true // Show the alert if nothing has changed
        } else {
            do {
                try await viewModel.updateTodo(editedTodo)
                onEditingComplete()
            } catch {
                print("Error updating todo: \(error)")
            }
        }
    }
}

