//
//  PlantsListView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/23/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct PlantsListView<T>: View where T: Store {
    @ObservedObject var store: T
    @Binding var selectedPlant: Plant?

    @State private var showingSheet = false
    @State private var isSheetSearch = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                searchButton
                sortButton
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            List(store.allPlants, selection: $selectedPlant) { plant in
                let photo = store.photos(for: plant)
                    .sorted { $0.timestamp > $1.timestamp }
                    .first
                NavigationLink(value: plant) {
                    PlantRow(viewModel: PlantRowViewModel(plant: plant, photo: photo))
                }
            }
            Spacer()
        }
        .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
            if isSheetSearch {
                searchSheet
            } else {
                sortSheet
            }
        }
    }

    private var searchButton: some View {
        Button {
            showingSheet = true
            isSheetSearch = true
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }

    private var sortButton: some View {
        Button {
            showingSheet = true
            isSheetSearch = false
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    private var sortSheet: ActionSheet {
        let buttons: [ActionSheet.Button] = [
            .default(Text("Name"), action: {
                //                self.sort()
            }),
            .default(Text("Category"), action: {
                //                self.search()
            }),
            .cancel()
        ]
        return ActionSheet(title: Text("Sort plants by:"), message: nil, buttons: buttons)
    }

    private var searchSheet: ActionSheet {
        let buttons: [ActionSheet.Button] = [
            .default(Text("Search"), action: {
                //                self.sort()
            }),
            .cancel()
        ]
        return ActionSheet(title: Text("Search"), message: nil, buttons: buttons)
    }
}
