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

    override func setUp() {
        super.setUp()
        repositoryMock = UserListRepositoryMock()
        viewModel = UserListViewModel(repository: repositoryMock)
    }
    
    // MARK: - Tear Down

    override func tearDown() {
        viewModel = nil
        repositoryMock = nil
        super.tearDown()
    }

    // MARK: - Tests

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
        XCTAssertEqual(viewModel.users.count, mockUsers.count)
        XCTAssertEqual(viewModel.users[0].name.first, mockUsers[0].name.first)
        XCTAssertEqual(viewModel.users[1].name.first, mockUsers[1].name.first)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchUsersFailure() {
        // Given
        repositoryMock.fetchUsersResult = .failure(NSError(domain: "Test", code: 1, userInfo: nil))
        
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
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
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
        let result = viewModel.shouldLoadMoreData(currentItem: user2)
        
        // Then
        XCTAssertTrue(result)
    }
    
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
        let result = viewModel.shouldLoadMoreData(currentItem: user1)
        
        // Then
        XCTAssertFalse(result)
    }
    
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
        let result = viewModel.shouldLoadMoreData(currentItem: user2)
        
        // Then
        XCTAssertFalse(result)
    }
    
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
            repositoryMock.fetchUsersResult = .success(mockUsers)
            
            // Populate initial users
            viewModel.users = mockUsers

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
            XCTAssertEqual(viewModel.users.count, mockUsers.count)
            XCTAssertEqual(viewModel.users[0].name.first, mockUsers[0].name.first)
            XCTAssertEqual(viewModel.users[1].name.first, mockUsers[1].name.first)
            XCTAssertFalse(viewModel.isLoading)
        }
}
