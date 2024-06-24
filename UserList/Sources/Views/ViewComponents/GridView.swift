//
//  GridView.swift
//  UserList
//
//  Created by Margot Pasquali on 21/06/2024.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
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
                                    Color.gray // Utilisez une couleur pour le placeholder
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
    GridView().environmentObject(ViewModel())
}


