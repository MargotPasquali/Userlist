import Foundation

class UserListRepository {

    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)

    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.executeDataRequest = executeDataRequest
    }

    func fetchUsers(quantity: Int) async throws -> [User] {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw URLError(.badURL)
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "results", value: "\(quantity)")]

        guard let requestUrl = urlComponents?.url else {
            throw URLError(.badURL)
        }

        let request = URLRequest(url: requestUrl)
        let (data, _) = try await executeDataRequest(request)

        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
        
        return response.results.map(User.init)
    }
}

