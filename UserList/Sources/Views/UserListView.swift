//
//  UserListView2.swift
//  UserList
//
//  Created by Margot Pasquali on 20/06/2024.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isGridView {
                    GridView()
                        .environmentObject(viewModel) // Passez ViewModel via l'environnement
                } else {
                    ListView()
                        .environmentObject(viewModel) // Passez ViewModel via l'environnement
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DisplayPicker(isGridView: $viewModel.isGridView) // Binding pour DisplayPicker
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    reloadButton
                }
            }
        }
        .onAppear { viewModel.fetchUsers() }
    }
    
    
    var reloadButton: some View {
        Button(action: viewModel.reloadUsers) {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
        }
    }
    
}

#Preview {
    UserListView()
}
