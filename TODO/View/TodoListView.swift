import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var selection: Set<Int> = []
    @State private var isEditing = false
    @State private var isPresentingEditSheet = false
    @State private var selectedTodo: TodoElement?

    // New state variable to track the sheet presentation
    @State private var presentSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    VStack(alignment: .leading) {
                        Text("Title: \(todo.title)")
                        Text("Priority: \(todo.priority)")
                    }
                    .background(
                        // Highlight selected rows
                        Color(selection.contains(todo.id) ? .blue : .clear)
                            .opacity(0.3)
                    )
                    .overlay(
                        Button(action: {
                            // Present the edit sheet when the button is tapped
                            selectedTodo = todo
                            presentSheet.toggle()
                        }) {
                            Color.clear // Make the entire VStack tappable
                        }
                    )
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.deleteTodo(at: index)
                    }
                }
            }
            .sheet(isPresented: $presentSheet) { // Use separate state for sheet presentation
                if let selectedTodo = selectedTodo {
                    EditTodoView(viewModel: viewModel, todo: selectedTodo) {
                        // Update the selection after editing
                        selection.removeAll()
                        presentSheet = false // Dismiss the sheet
                    }
                }
            }
            .onChange(of: presentSheet) { newValue in
                if newValue, let initialTodo = viewModel.todos.first {
                    selectedTodo = initialTodo
                }
            }
            .navigationTitle("MyTodos")
            .navigationBarItems(
                leading: Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                },
                trailing: NavigationLink(
                    destination: AddTodoItemView(viewModel: viewModel),
                    label: {
                        Image(systemName: "plus")
                    }
                )
            )
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
            .onAppear {
                viewModel.fetchData()
                // Initialize selectedTodo here if needed
                   if let initialTodo = viewModel.todos.first {
                       selectedTodo = initialTodo
                       presentSheet = true
                   }
            }
            .onDisappear {
                selection.removeAll()
                isEditing = false
            }
        }
    }
}
