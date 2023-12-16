//
//  PlantRowViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 12/11/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Combine
import UIKit

class PlantRowViewModel: ObservableObject, Identifiable {
    @Published var plant: Plant
    private var cancellables = Set<AnyCancellable>()

    var id: String?
    var name: String = ""
    var categoryString: String = ""
    var categoryColor: UIColor = .clear
    var typeString: String = ""
    var typeColor: UIColor = .clear

    init(plant: Plant) {
        self.plant = plant

        // TODO: fetch the most recent photo id for the plan

        // assign id
        $plant
            .map{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)

        // assign text
        $plant
            .map{ $0.name }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)

        // assign category properties
        $plant
            .map{ $0.category.rawValue }
            .assign(to: \.categoryString, on: self)
            .store(in: &cancellables)

        $plant
            .map{ self.color(for: $0.category) }
            .assign(to: \.categoryColor, on: self)
            .store(in: &cancellables)

        // assign type properties
        $plant
            .map{ $0.type.rawValue }
            .assign(to: \.typeString, on: self)
            .store(in: &cancellables)

        $plant
            .map{ self.color(for: $0.type) }
            .assign(to: \.typeColor, on: self)
            .store(in: &cancellables)
    }

    func color(for category: Category) -> UIColor {
        switch category {
        case .herb:
            return .green
        case .vegetable:
            return .blue
        case .unknown:
            return .red
        }
    }

    func color(for type: PlantType) -> UIColor {
        switch type {
        case .lettuce:
            return .green
        case .cucumber:
            return .blue
        case .tomato:
            return .red
        case .unknown:
            return .yellow
        }
    }
}
