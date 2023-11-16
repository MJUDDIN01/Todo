
import SwiftUI

struct AddTodoItemView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var newTodoTitle = ""
    @State private var newTodoPriority = ""
    @Binding var isPresentingAddTodoView: Bool

    var isAddButtonEnabled: Bool {
        return newTodoTitle.count >= 3 && newTodoPriority.count >= 3
    }

    var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            VStack {
                TextField("Add your todo here...", text: $newTodoTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Set the Priority: Low/Medium/High", text: $newTodoPriority)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Add Todo") {
                    Task {
                        await addTodo()
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(isAddButtonEnabled ? Color.brown : Color.gray)
                .cornerRadius(8)
                .padding()
                .disabled(!isAddButtonEnabled)
            }
            .padding()
            .navigationTitle("Add New Todo")
        }
    }

    func addTodo() async {
        await viewModel.addTodo(title: newTodoTitle, priority: newTodoPriority)
        isPresentingAddTodoView = false
    }
}
