//
//  UserListView2.swift
//  UserList
//
//  Created by Margot Pasquali on 20/06/2024.
//

import SwiftUI

struct UserListView2: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            Group {
                if !viewModel.isGridView {
                    userList
                } else {
                    gridView
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    displayPicker
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    reloadButton
                }
            }
        }
        .onAppear { viewModel.fetchUsers() }
    }

    var userList: some View {
        List(viewModel.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
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
                        Text("\(user.dob.date)")
                            .font(.subheadline)
                    }
                }            }
            .onAppear {
                if viewModel.shouldLoadMoreData(currentItem: user) {
                    viewModel.fetchUsers()
                }
            }
        }
    }

    var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        VStack {
                            AsyncImage(url: URL(string: user.picture.medium)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }
                            
                            Text("\(user.name.first) \(user.name.last)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .onAppear {
                        if viewModel.shouldLoadMoreData(currentItem: user) {
                            viewModel.fetchUsers()
                        }
                    }
                }
            }
        }
    }

    var displayPicker: some View {
        Picker("Display", selection: $viewModel.isGridView) {
            Image(systemName: "rectangle.grid.1x2.fill")
                .tag(true)
                .accessibilityLabel(Text("Grid view"))
            Image(systemName: "list.bullet")
                .tag(false)
                .accessibilityLabel(Text("List view"))
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    var reloadButton: some View {
        Button(action: viewModel.reloadUsers) {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
        }
    }
}

#Preview {
    UserListView2()
}
