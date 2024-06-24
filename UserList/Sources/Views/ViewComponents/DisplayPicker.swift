//
//  DisplayPicker.swift
//  UserList
//
//  Created by Margot Pasquali on 21/06/2024.
//

import SwiftUI

struct DisplayPicker: View {
    @Binding var isGridView: Bool // Utiliser Binding pour propager l'état
    
    var body: some View {
        Picker("Display", selection: $isGridView) {
            Image(systemName: "rectangle.grid.1x2.fill")
                .tag(true)
                .accessibilityLabel(Text("Grid view"))
            Image(systemName: "list.bullet")
                .tag(false)
                .accessibilityLabel(Text("List view"))
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

#Preview {
    DisplayPicker(isGridView: .constant(true)) // Pour la prévisualisation, utilisez .constant
}

