import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var selection: Set<Int> = []
    @State private var isEditing = false

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
                }
                .onDelete(perform: deleteTodos)
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
            }
            .onDisappear {
                // Clear selection when the view disappears (e.g., when "Done" is tapped)
                selection.removeAll()
                isEditing = false // Dismiss edit mode
            }
        }
    }

    private func deleteTodos(offsets: IndexSet) {
        withAnimation {
            // Remove selected todos from the local array
            viewModel.todos.remove(atOffsets: offsets)
        }

        // Clear selection after deletion
        selection.removeAll()
    }
}