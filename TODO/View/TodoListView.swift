import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var selection: Set<Int> = []
    @State private var isEditing = false
    @State private var selectedTodo: TodoElement?
    @State private var isPresentingAddTodoView = false
    var presentationMode: Binding<PresentationMode>
    
    // New state variable to track the sheet presentation
    @State private var presentSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Title: \(todo.title)")
                                Text("Priority: \(todo.priority)")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .background(
                        // Highlight selected rows
                        Color(selection.contains(Int(todo.id) ?? 0) ? .blue : .clear)
                            .opacity(0.3)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Set the selectedTodo when a todo is tapped
                        selectedTodo = todo
                        presentSheet = true // Open the sheet
                    }
                }
                .onDelete { indexSet in
                    Task {
                        for index in indexSet {
                            await viewModel.deleteTodo(at: index)
                        }
                    }
                }
            }
                // Use separate state for sheet presentation
                .sheet(isPresented: $presentSheet) {
                    if let selectedTodo = selectedTodo {
                        EditTodoView(viewModel: viewModel, todo: selectedTodo) {
                            // Update the selection after editing
                            selection.removeAll()
                            // Dismiss the sheet
                            presentSheet = false
                        }
                    }
                }
                .onChange(of: presentSheet) { newValue in
                    if newValue, let todo = selectedTodo, let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) {
                        // Update the selectedTodo only when the sheet is about to be presented
                        selectedTodo = viewModel.todos[index]
                    }
                }
                .navigationTitle("MyTodos")
                .navigationBarItems(
                    leading: Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    },
                    trailing: Button(action: {
                        // Reset selectedTodo and close the sheet if it's open
                        selectedTodo = nil
                        presentSheet = false
                        // Present the AddTodoItemView
                        isPresentingAddTodoView = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $isPresentingAddTodoView) {
                    AddTodoItemView(
                        viewModel: viewModel,
                        isPresentingAddTodoView: $isPresentingAddTodoView,
                        presentationMode: presentationMode
                    )
                }
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .onAppear {
                    Task {
                           await viewModel.fetchData()
                           // Initialize selectedTodo here if needed
                           if let initialTodo = viewModel.todos.first {
                               DispatchQueue.main.async {
                                   selectedTodo = initialTodo
                                   presentSheet = false
                               }
                           }
                       }
                   }
                .onDisappear {
                    selection.removeAll()
                    isEditing = false
                }
            }
        }
    }
