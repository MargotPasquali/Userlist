//
//  ListView.swift
//  UserList
//
//  Created by Margot Pasquali on 21/06/2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var viewModel: UserListViewModel

    var body: some View {
        List(viewModel.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
                ListRow(user: user)
            }
            .onAppear {
                if viewModel.shouldLoadMoreData(currentItem: user) {
                    viewModel.fetchUsers()
                }
            }
        }
        .navigationTitle("Users")
        .onAppear {
            if viewModel.users.isEmpty {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ListView().environmentObject(UserListViewModel(repository: UserListRepository()))
}
