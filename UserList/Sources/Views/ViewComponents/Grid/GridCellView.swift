//
//  GridCellView.swift
//  UserList
//
//  Created by Margot Pasquali on 26/06/2024.
//

import SwiftUI

struct GridCellView: View {
    
    @EnvironmentObject var viewModel: UserListViewModel
    var user: User

    
    var body: some View {
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
}
