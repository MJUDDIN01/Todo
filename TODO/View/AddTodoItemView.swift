
import SwiftUI

struct AddTodoItemView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var newTodoTitle = ""
    @State private var newTodoPriority = ""
    @Binding var isPresentingAddTodoView: Bool

    private var isAddButtonEnabled: Bool {
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
                        await addTodoAndUpdateList()
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

    private func addTodoAndUpdateList() async {
        do {
            // Add the new todo
            try await viewModel.addTodo(title: newTodoTitle, priority: newTodoPriority)
            
            // Fetch updated data after adding the todo
            await viewModel.fetchData()

            // Close the sheet
            isPresentingAddTodoView = false
        } catch {
            print("Error adding and fetching todo: \(error)")
        }
    }
}
