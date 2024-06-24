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
                getList(user: user) 
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
    
    // Définition de la fonction getList
    private func getList(user: User) -> some View {
        HStack {
            AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text(user.formattedDateOfBirth)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    ListView().environmentObject(UserListViewModel())
}
