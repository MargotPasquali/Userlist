//
//  UserListRepositoryMock.swift
//  UserListTests
//
//  Created by Margot Pasquali on 25/06/2024.
//

import Foundation
@testable import UserList

class UserListRepositoryMock: UserListRepository {
    var fetchUsersResult: Result<[User], Error>?

    override func fetchUsers(quantity: Int) async throws -> [User] {
        switch fetchUsersResult {
        case .success(let users):
            return users
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "Mock error", code: 0, userInfo: nil)
        }
    }
}
