
import SwiftUI

struct AddTodoItemView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var newTodoTitle = ""
    @State private var newTodoPriority = ""
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Title", text: $newTodoTitle)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Priority", text: $newTodoPriority)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add Todo") {
                viewModel.addTodo(title: newTodoTitle, priority: newTodoPriority)
                // Dismiss the view
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .padding()
        }
        .padding()
        .navigationTitle("Add Todo")
    }
}
