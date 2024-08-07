//
//  ViewModel.swift
//  UserList
//
//  Created by Margot Pasquali on 11/06/2024.
//

import Foundation

class UserListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    
    // MARK: - Private Properties

    private var repository: UserListRepository
    
    // MARK: - Init

    init(repository: UserListRepository) {
        self.repository = repository
    }
    
    // MARK: - Methods

    // Charge une liste utilisateurs à partir du repository et met à jour users
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                DispatchQueue.main.async {
//                    print("Fetched user DOBs: \(users.map { $0.dob.date })") // impression sur la console pour obtenir le bon format de date
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error fetching users: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }

    // Détermine si de nouvelles données doivent être chargées
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    // Efface la liste actuelle avec removeAll() et déclenche une nouvelle récupération de données avec fetchUsers()
    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
