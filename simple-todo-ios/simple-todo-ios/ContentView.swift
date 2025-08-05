//
//  ContentView.swift
//  simple-todo-ios
//
//  Created by Malik Abdul Ghani on 05/08/25.
//

import SwiftUI

 struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New todo", text: $viewModel.newTodo)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") {
                        Task { await viewModel.addTodo() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()

                List {
                    ForEach(viewModel.todos) { todo in
                        Text(todo.name)
                    }
                    .onDelete { offsets in
                        Task { await viewModel.deleteTodo(at: offsets) }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Todos")
            .alert(item: $viewModel.errorMessage) { msg in
                Alert(title: Text("Error"), message: Text(msg), dismissButton: .default(Text("OK")))
            }
        }
        .task { await viewModel.loadTodos() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
