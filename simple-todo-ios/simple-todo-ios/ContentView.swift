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
                    TextField("Enter new todo…", text: $viewModel.newTodo)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    Button(action: { Task { await viewModel.addTodo() } }) {
                        Text("Add")
                            .font(.headline)
                            .frame(minWidth: 60)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .controlSize(.large)
                }
                .padding()

                List {
                    ForEach(viewModel.todos) { todo in
                        HStack {
                            Text(todo.name)
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    .onDelete { offsets in
                        Task { await viewModel.deleteTodo(at: offsets) }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.loadTodos()
                }
                .animation(.easeInOut, value: viewModel.todos)
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
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
