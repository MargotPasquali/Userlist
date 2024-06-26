//
//  GridView.swift
//  UserList
//
//  Created by Margot Pasquali on 21/06/2024.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var viewModel: UserListViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        GridCellView(user: user)
                        }
                        .frame(width: 150, height: 150)
                        .clipped()
                        .padding(.bottom, 8)
                    .onAppear {
                        if viewModel.shouldLoadMoreData(currentItem: user) {
                            viewModel.fetchUsers()
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            if viewModel.users.isEmpty {
                viewModel.fetchUsers()
            }
        }
    }
}


#Preview {
    GridView().environmentObject(UserListViewModel(repository: UserListRepository()))
}

