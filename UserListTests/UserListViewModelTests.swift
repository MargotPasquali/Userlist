//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Margot Pasquali on 24/06/2024.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {
    
    // MARK: - Properties

    var viewModel: UserListViewModel!
    var repositoryMock: UserListRepositoryMock!

    // MARK: - Setup

    // appel de setUp() avant chaque test individuel. Elle initialise l'état nécessaire pour les tests. Cela permet de s'assurer que chaque test commence dans un état connu et cohérent.
    override func setUp() {
        super.setUp()
        repositoryMock = UserListRepositoryMock()
        viewModel = UserListViewModel(repository: repositoryMock)
    }
    
    // MARK: - Tear Down

    // Appel de tearDown() après chaque test individuel. Elle est utilisée pour nettoyer l'état après chaque test. Cela aide à s'assurer qu'aucun état persistant ou effets secondaires des tests précédents n'affectent les tests suivants.
    override func tearDown() {
        viewModel = nil
        repositoryMock = nil
        super.tearDown()
    }

    // MARK: - Tests

    
    // Vérifie que fetchUsers() récupère correctement les utilisateurs et met à jour les propriétés du viewModel (users et isLoading) comme attendu en cas de succès
    func testFetchUsersSuccess() {
        // Given
        let mockUsers = [
            User(user: UserListResponse.User(
                name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
                dob: UserListResponse.User.Dob(date: "1988-02-19T03:10:19.274Z", age: 34),
                picture: UserListResponse.User.Picture(
                    large: "https://randomuser.me/api/portraits/men/1.jpg",
                    medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                    thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
                )
            )),
            User(user: UserListResponse.User(
                name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"),
                dob: UserListResponse.User.Dob(date: "1990-05-10T00:00:00Z", age: 30),
                picture: UserListResponse.User.Picture(
                    large: "https://randomuser.me/api/portraits/women/1.jpg",
                    medium: "https://randomuser.me/api/portraits/med/women/1.jpg",
                    thumbnail: "https://randomuser.me/api/portraits/thumb/women/1.jpg"
                )
            ))
        ]
        repositoryMock.fetchUsersResult = .success(mockUsers)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch users")
        Task {
            await viewModel.fetchUsers()
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.users.count, mockUsers.count) // Vérifie que le nombre d'utilisateurs dans le viewModel est égal au nombre d'utilisateurs dans le mock
        XCTAssertEqual(viewModel.users[0].name.first, mockUsers[0].name.first) // Vérifie que le premier prénom de l'utilisateur récupéré correspond à celui du mock
        XCTAssertEqual(viewModel.users[1].name.first, mockUsers[1].name.first) // Vérifie que le deuxième prénom de l'utilisateur récupéré correspond à celui du mock
        XCTAssertFalse(viewModel.isLoading) // Vérifie que l'état isLoading est false après la récupération des utilisateurs
    }

    
    // Vérifie que fetchUsers() gère correctement les erreurs et met à jour les propriétés du viewModel (users et isLoading) comme attendu en cas d'échec
    func testFetchUsersFailure() {
        // Given
        repositoryMock.fetchUsersResult = .failure(NSError(domain: "Test", code: 1, userInfo: nil)) // Simule une défaillance lors de la récupération des users
        
        // When
        let expectation = XCTestExpectation(description: "Fetch users")
        Task {
            await viewModel.fetchUsers()
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(viewModel.users.isEmpty) // Vérifie que la liste des utilisateurs dans le viewModel est vide après l'échec de la récupération
        XCTAssertFalse(viewModel.isLoading) // Vérifie que l'état isLoading est false après l'échec de la récupération des users
    }
    
    
    // Vérifie que shouldLoadMoreData(currentItem:) retourne true lorsqu'elle est appelée avec le dernier utilisateur de la liste, et que l'état de chargement (isLoading) est false. Le viewModel doit charger plus de données
    func testShouldLoadMoreDataTrue() {
        // Given
        let user1 = User(user: UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1988-02-19T03:10:19.274Z", age: 34),
            picture: UserListResponse.User.Picture(
                large: "https://randomuser.me/api/portraits/men/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
            )
        ))
        let user2 = User(user: UserListResponse.User(
            name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"),
            dob: UserListResponse.User.Dob(date: "1990-05-10T00:00:00Z", age: 30),
            picture: UserListResponse.User.Picture(
                large: "https://randomuser.me/api/portraits/women/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/women/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/women/1.jpg"
            )
        ))
        viewModel.users = [user1, user2]
        viewModel.isLoading = false

        // When
        let result = viewModel.shouldLoadMoreData(currentItem: user2) // On appelle le dernier user de la liste pour charger plus de données
        
        // Then
        XCTAssertTrue(result) // Vérifie que le résultat de shouldLoadMoreData(currentItem:) est true
    }
    
    
    // Vérifie que shouldLoadMoreData(currentItem:) retourne false lorsqu'elle est appelée avec un utilisateur qui n'est pas le dernier dans la liste, même si l'état de chargement (isLoading) est false
    func testShouldLoadMoreDataFalseWhenNotLastItem() {
        // Given
        let user1 = User(user: UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1988-02-19T03:10:19.274Z", age: 34),
            picture: UserListResponse.User.Picture(
                large: "https://randomuser.me/api/portraits/men/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
            )
        ))
        let user2 = User(user: UserListResponse.User(
            name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"),
            dob: UserListResponse.User.Dob(date: "1990-05-10T00:00:00Z", age: 30),
            picture: UserListResponse.User.Picture(
                large: "https://randomuser.me/api/portraits/women/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/women/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/women/1.jpg"
            )
        ))
        viewModel.users = [user1, user2]
        viewModel.isLoading = false

        // When
        let result = viewModel.shouldLoadMoreData(currentItem: user1) // user1 n'est donc pas le dernier user de la liste
        
        // Then
        XCTAssertFalse(result) // Vérifie que le résultat retourne faux
    }
    
    
    // Vérifie que shouldLoadMoreData(currentItem:) retourne false lorsqu'elle est appelée avec le dernier utilisateur de la liste, mais que le viewModel est en cours de chargement (isLoading est true). Le viewModel ne doit pas charger plus de données si un chargement est déjà en cours
    func testShouldLoadMoreDataFalseWhenLoading() {
        // Given
        let user1 = User(user: UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1988-02-19T03:10:19.274Z", age: 34),
            picture: UserListResponse.User.Picture(
                large: "https://randomuser.me/api/portraits/men/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
            )
        ))
        let user2 = User(user: UserListResponse.User(
            name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"),
            dob: UserListResponse.User.Dob(date: "1990-05-10T00:00:00Z", age: 30),
            picture: UserListResponse.User.Picture(
                large: "https://randomuser.me/api/portraits/women/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/women/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/women/1.jpg"
            )
        ))
        viewModel.users = [user1, user2]
        viewModel.isLoading = true

        // When
        let result = viewModel.shouldLoadMoreData(currentItem: user2) // Le dernier élément de la liste est bien user2
        
        // Then
        XCTAssertFalse(result) // Le résultat doit retourner faux car isLoading est true
    }
    
    
    // Vérifier que reloadUsers() fonctionne correctement. Cette méthode doit vider la liste actuelle des utilisateurs et recharger de nouveaux utilisateurs en appelant fetchUsers(). Le test vérifie que la liste des utilisateurs est correctement mise à jour et que l'état de chargement (isLoading) est correctement géré
    func testReloadUsers() {
        // Given
        let mockUsers = [
            User(user: UserListResponse.User(
                name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
                dob: UserListResponse.User.Dob(date: "1988-02-19T03:10:19.274Z", age: 34),
                picture: UserListResponse.User.Picture(
                    large: "https://randomuser.me/api/portraits/men/1.jpg",
                    medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                    thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
                )
            )),
            User(user: UserListResponse.User(
                name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"),
                dob: UserListResponse.User.Dob(date: "1990-05-10T00:00:00Z", age: 30),
                picture: UserListResponse.User.Picture(
                    large: "https://randomuser.me/api/portraits/women/1.jpg",
                    medium: "https://randomuser.me/api/portraits/med/women/1.jpg",
                    thumbnail: "https://randomuser.me/api/portraits/thumb/women/1.jpg"
                )
            ))
        ]
        repositoryMock.fetchUsersResult = .success(mockUsers) // Retourner ces utilisateurs avec succès
        
        // Populate initial users
        viewModel.users = mockUsers // Initialisation de viewModel.users avec mockUsers
        
        // When
        let expectation = XCTestExpectation(description: "Reload users")
        Task {
            await viewModel.reloadUsers()
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.users.count, mockUsers.count) // Vérifie que le nombre d'utilisateurs dans le viewModel est égal au nombre d'utilisateurs dans le mock
        XCTAssertEqual(viewModel.users[0].name.first, mockUsers[0].name.first) // Vérifie que le premier prénom de l'utilisateur récupéré correspond à celui du mock
        XCTAssertEqual(viewModel.users[1].name.first, mockUsers[1].name.first) // Vérifie que le deuxième prénom de l'utilisateur récupéré correspond à celui du mock
        XCTAssertFalse(viewModel.isLoading) // Vérifie que l'état isLoading est false après la récupération des users
        
    }
}
