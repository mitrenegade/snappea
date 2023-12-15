//
//  PlantRow.swift
//  Snappy
//
//  Created by Bobby Ren on 12/11/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PlantRow: View {
    @ObservedObject var plantRowViewModel: PlantRowViewModel

    init(plant: Plant) {
        self.plantRowViewModel = PlantRowViewModel(plant: plant)
    }

    var body: some View {
        HStack {
            Text($plantRowViewModel.name.wrappedValue)
            Text($plantRowViewModel.categoryString.wrappedValue)
                .foregroundColor(Color($plantRowViewModel.categoryColor.wrappedValue))
            Text($plantRowViewModel.typeString.wrappedValue)
                .foregroundColor(Color($plantRowViewModel.typeColor.wrappedValue))
        }
    }
}

#Preview {
    PlantRow(plant: Stub.plantData[0])
}

//struct PlantRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantRow(plant: Stub.plantData[0])
//    }
//}
