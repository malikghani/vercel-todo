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
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
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
