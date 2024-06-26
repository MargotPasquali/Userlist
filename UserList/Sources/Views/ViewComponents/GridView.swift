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
                        ZStack {
                                AsyncImage(url: URL(string: user.picture.large)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                } placeholder: {
                                    Color.white
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                }
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.clear, Color.gray.opacity(0.3), Color.black.opacity(0.6)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 150, height: 150)
                            VStack {
                                Spacer()
                                Text("\(user.name.first) \(user.name.last)")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.white)
                                        .padding(.bottom, 10)
                            }
                                
                            }
                            .frame(width: 150, height: 150)
                            .clipped()
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

