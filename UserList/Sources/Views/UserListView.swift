//
//  UserListView2.swift
//  UserList
//
//  Created by Margot Pasquali on 20/06/2024.
//
import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
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
                    ReloadButton()
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
        .environmentObject(viewModel) // Nécessité de passer ViewModel par rapport à la preview de ReloadButton
    }
}

#Preview {
    UserListView()
}
