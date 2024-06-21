//
//  ViewModel.swift
//  UserList
//
//  Created by Margot Pasquali on 11/06/2024.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    
    let repository = UserListRepository()
    
    
    // fonction modifiée pour que les modifications apportées à users et isLoading soient sur le thread principal
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                DispatchQueue.main.async {  // S'assurer que les mises à jour de l'état se font sur le thread principal
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error fetching users: \(error.localizedDescription)")
                    self.isLoading = false  // Même ici, assurez-vous de revenir au thread principal
                }
            }
        }
    }

    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }


    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
