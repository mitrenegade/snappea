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
    @State private var sortType: SortType = .nameAZ

    private var plantsForPhotos: [String: String] {
        var dict = [String: String]()
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                dict[photo.id] = plant.id
            }
        })
        return dict
    }

    private var allPhotos: [Photo] {
        var photos = [Photo]()
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                photos.append(photo)
            }
        })
        return photos
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                searchButton
                sortButton
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            List(sorted(store.allPlants, by: sortType), selection: $selectedPlant) { plant in
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

    private func sorted(_ plants: [Plant], by sortType: SortType) -> [Plant] {
        switch sortType {
        case .nameAZ:
            return plants.sorted { $0.name < $1.name }
        case .nameZA:
            return plants.sorted { $0.name > $1.name }
        case .categoryAZ:
            return plants.sorted { $0.category < $1.category }
        case .categoryZA:
            return plants.sorted { $0.category > $1.category }
        case .dateOldest:
            let sortedPhotos = allPhotos.sorted { lhs, rhs in
                lhs.timestamp < rhs.timestamp
            }
            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
            let plants = plantIDs.compactMap { plantId in
                plants.first { $0.id == plantId }
            }
            return plants
        case .dateNewest:
            let sortedPhotos = allPhotos.sorted { lhs, rhs in
                lhs.timestamp > rhs.timestamp
            }
            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
            let plants = plantIDs.compactMap { plantId in
                plants.first { $0.id == plantId }
            }
            return plants
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
                sortType = .nameAZ
            }),
            .default(Text("Name (Z->A)"), action: {
                sortType = .nameZA
            }),
            .default(Text("Category (A->Z)"), action: {
                sortType = .categoryAZ
            }),
            .default(Text("Category (Z->A)"), action: {
                sortType = .categoryZA
            }),
            .default(Text("Date Updated (Oldest first)"), action: {
                sortType = .dateOldest
            }),
            .default(Text("Date Updated (Newest first)"), action: {
                sortType = .dateNewest
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
