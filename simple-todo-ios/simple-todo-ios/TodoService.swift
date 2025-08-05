import Foundation

enum TodoServiceError: Error, LocalizedError {
    case invalidURL
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .serverError(let msg): return msg
        }
    }
}

struct ListResponse: Codable {
    let todos: [Todo]
}
struct AddResponse: Codable {
    let name: String
}
struct DeleteResponse: Codable {
    let success: Bool
}

struct Todo: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
}

class TodoService {
    // Use the same base URL as your backend deployment (Vercel or Supabase function gateway)
    private let baseURL = "https://erljroubjknqplalateu.supabase.co"

    func fetchTodos() async throws -> [Todo] {
        guard let url = URL(string: "\(baseURL)/api/list_todo") else { throw TodoServiceError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ListResponse.self, from: data)
        return response.todos
    }

    func addTodo(name: String) async throws {
        guard let url = URL(string: "\(baseURL)/api/add_todo") else { throw TodoServiceError.invalidURL }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(["name": name])
        let (data, _) = try await URLSession.shared.data(for: req)
        let res = try JSONDecoder().decode(AddResponse.self, from: data)
        if res.name != name { throw TodoServiceError.serverError("Add failed") }
    }

    func deleteTodo(name: String) async throws {
        guard let url = URL(string: "\(baseURL)/api/delete_todo") else { throw TodoServiceError.invalidURL }
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(["name": name])
        let (data, _) = try await URLSession.shared.data(for: req)
        let res = try JSONDecoder().decode(DeleteResponse.self, from: data)
        if !res.success { throw TodoServiceError.serverError("Delete failed or not found") }
    }
}
