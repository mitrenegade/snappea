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

//    @State private var allPlants: [Plant] = []

//    private lazy var plantsForPhotos: [String: String] = {
//        var dict = [String: String]()
//        store.allPlants.forEach({ plant in
//            if let photo = store.latestPhoto(for: plant) {
//                dict[photo.id] = plant.id
//            }
//        })
//        return dict
//    }()
//    private lazy var allPhotos: [Photo] = {
//        var photos = [Photo]()
//        store.allPlants.forEach({ plant in
//            if let photo = store.latestPhoto(for: plant) {
//                photos.append(photo)
//            }
//        })
//        return photos
//    }()

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
        default:
            return plants
        }
    }

    /*
    private mutating func sort(by type: SortType) -> [Plant] {
        switch type {
        case .nameAZ:
            return store.allPlants.sorted { $0.name < $1.name }
        case .nameZA:
            return store.allPlants.sorted { $0.name > $1.name }
        case .categoryAZ:
            return store.allPlants.sorted { $0.category < $1.category }
        case .categoryZA:
            return store.allPlants.sorted { $0.category > $1.category }
        case .dateOldest:
            return []
     */
//            let sortedPhotos = allPhotos.sorted { lhs, rhs in
//                lhs.timestamp < rhs.timestamp
//            }
//            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
//            let plants = plantIDs.compactMap { plantId in
//                allPlants.first { $0.id == plantId }
//            }
//            return plants
//        case .dateNewest:
//            let sortedPhotos = allPhotos.sorted { lhs, rhs in
//                lhs.timestamp > rhs.timestamp
//            }
//            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
//            let plants = plantIDs.compactMap { plantId in
//                allPlants.first { $0.id == plantId }
//            }
//            return []
//        }
//    }

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
                //allPlants = self.sort(by: .nameAZ)
            }),
            .default(Text("Name (Z->A)"), action: {
                sortType = .nameZA
//                allPlants = self.sort(by: .nameAZ)
            }),
            .default(Text("Category (A->Z)"), action: {
//                allPlants = self.sort(by: .nameAZ)
            }),
            .default(Text("Category (Z->A)"), action: {
//                allPlants = self.sort(by: .nameAZ)
            }),
            .default(Text("Date Updated (Oldest first)"), action: {
//                allPlants = self.sort(by: .nameAZ)
            }),
            .default(Text("Date Updated (Newest first)"), action: {
//                allPlants = self.sort(by: .nameAZ)
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
