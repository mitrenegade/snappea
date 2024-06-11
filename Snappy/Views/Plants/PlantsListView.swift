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

    private enum SortType {
        case nameAZ
        case nameZA
        case categoryAZ
        case categoryZA
        case dateOldest
        case dateNewest
    }

    @ObservedObject var store: T
    @Binding var selectedPlant: Plant?

    @State private var showingSheet = false
    @State private var sheetType: SheetType = .none

    var body: some View {
        VStack {
            HStack {
                Spacer()
                searchButton
                sortButton
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            List(store.allPlants, selection: $selectedPlant) { plant in
                let photo = store.latestPhoto(for: plant)
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

    private func sort(by type: SortType) {
        switch type {
        case .nameAZ:
            break
        case .nameZA:
            break
        case .categoryAZ:
            break
        case .categoryZA:
            break
        case .dateOldest:
            break
        case .dateNewest:
            break
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
                self.sort(by: .nameAZ)
            }),
            .default(Text("Name (Z->A)"), action: {
                self.sort(by: .nameAZ)
            }),
            .default(Text("Category (A->Z)"), action: {
                self.sort(by: .nameAZ)
            }),
            .default(Text("Category (Z->A)"), action: {
                self.sort(by: .nameAZ)
            }),
            .default(Text("Date Updated (Oldest first)"), action: {
                self.sort(by: .nameAZ)
            }),
            .default(Text("Date Updated (Newest first)"), action: {
                self.sort(by: .nameAZ)
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
