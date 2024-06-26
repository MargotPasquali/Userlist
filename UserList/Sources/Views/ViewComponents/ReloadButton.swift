//
//  ReloadButton.swift
//  UserList
//
//  Created by Margot Pasquali on 24/06/2024.
//

import SwiftUI

struct ReloadButton: View {
    
    @EnvironmentObject var viewModel: UserListViewModel

    var body: some View {
            Button(action: viewModel.reloadUsers) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        }
    }


#Preview {
    ReloadButton().environmentObject(UserListViewModel(repository: UserListRepository()))
}
