//
//  ListRow.swift
//  UserList
//
//  Created by Margot Pasquali on 26/06/2024.
//

import SwiftUI

struct ListRow: View {
    
    @EnvironmentObject var viewModel: UserListViewModel
    var user: User
    
    var body: some View {
            HStack {
                AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
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

