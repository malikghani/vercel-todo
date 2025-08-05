import Foundation
import SwiftUI

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var newTodo: String = ""
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    private let service = TodoService()

    func loadTodos() async {
        do {
            todos = try await service.fetchTodos()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func addTodo() async {
        let name = newTodo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        do {
            try await service.addTodo(name: name)
            newTodo = ""
            await loadTodos()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func deleteTodo(at offsets: IndexSet) async {
        guard let index = offsets.first else { return }
        let name = todos[index].name
        do {
            try await service.deleteTodo(name: name)
            await loadTodos()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
