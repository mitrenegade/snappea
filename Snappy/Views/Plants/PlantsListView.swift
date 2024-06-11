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
    private enum SheetType {
        case sort
        case search
        case none
    }

    @Binding var selectedPlant: Plant?
    @ObservedObject var viewModel: PlantsListViewModel<T>

    @State private var showingSheet = false
    @State private var sheetType: SheetType = .none

    var body: some View {
        VStack {
            HStack {
                Spacer()
                searchButton
                sortButton
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            List(viewModel.sorted(), selection: $selectedPlant) { plant in
                let photo = viewModel.photo(for: plant)
                NavigationLink(value: plant) {
                    PlantRow(viewModel: PlantRowViewModel(plant: plant, photo: photo))
                }
            }
            Spacer()
        }
        .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
            if sheetType == .search {
                searchSheet
            } else {
                sortSheet
            }
        }
    }

    private var searchButton: some View {
        Button {
            showingSheet = true
            sheetType = .search
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }

    private var sortButton: some View {
        Button {
            showingSheet = true
            sheetType = .sort
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    private var sortSheet: ActionSheet {
        let buttons: [ActionSheet.Button] = [
            .default(Text("Name (A->Z)"), action: {
                viewModel.sortType = .nameAZ
            }),
            .default(Text("Name (Z->A)"), action: {
                viewModel.sortType = .nameZA
            }),
            .default(Text("Category (A->Z)"), action: {
                viewModel.sortType = .categoryAZ
            }),
            .default(Text("Category (Z->A)"), action: {
                viewModel.sortType = .categoryZA
            }),
            .default(Text("Date Updated (Oldest first)"), action: {
                viewModel.sortType = .dateOldest
            }),
            .default(Text("Date Updated (Newest first)"), action: {
                viewModel.sortType = .dateNewest
            }),
            .cancel()
        ]
        return ActionSheet(title: Text("Sort plants by:"), message: nil, buttons: buttons)
    }

    private var searchSheet: ActionSheet {
        let buttons: [ActionSheet.Button] = [
            .default(Text("Search"), action: {
                // no op
            }),
            .cancel()
        ]
        return ActionSheet(title: Text("Search"), message: nil, buttons: buttons)
    }
}
