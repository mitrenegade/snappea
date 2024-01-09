//
//  AddPlantView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/28/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct AddPlantView: View {

    @State var name: String = ""
    @State var category: Category = .other
    @State var plantType: PlantType = .unknown

    private var title: String {
        if TESTING {
            return "AddPlantView"
        } else {
            return "New plant"
        }
    }

    var body: some View {
        Text(title)
        VStack {
            addButton
            nameField
            categoryField
            typeField
        }
    }

    private var addButton: some View {
        HStack {
            Button {
                // camera
            } label: {
                Image(systemName: "camera")
            }
            .frame(width: 100, height: 100)
            .aspectRatio(contentMode: .fill)
            .foregroundColor(Color.black)
            .background(Color.green)
            .clipShape(Circle())
        }
    }

    private var nameField: some View {
        HStack {
            Spacer()
            TextField(text: $name) {
                Text("Plant name")
            }
            .border(.gray)
            Spacer()
        }
    }

    private var typeField: some View {
            List {
                Picker("Type", selection: $plantType) {
                    ForEach(PlantType.allCases) { plantType in
                        Text(plantType.rawValue.capitalized)
                    }
                }
            }
    }

    private var categoryField: some View {
            List {
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
            }
    }
}

#Preview {
    AddPlantView()
}
