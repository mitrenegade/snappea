//
//  Router.swift
//  Snappy
//
//  Created by Bobby Ren on 5/19/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

// https://stackoverflow.com/questions/77015145/how-to-do-programmatic-navigation-in-swiftui-using-navigationstack-once-state-ch
// https://blorenzop.medium.com/routing-navigation-in-swiftui-f1f8ff818937

/// Handles navigation between displaying galleries and add/edit functionality
import Foundation
import UIKit
import SwiftUI

final class Router: ObservableObject {
    public enum Destination: Hashable {
        case addImageToPlant(image: UIImage, plant: Plant)
        case createPlantWithImage(image: UIImage)
    }

    @Published var path = NavigationPath()

    func navigate(to destination: Destination) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }
}
