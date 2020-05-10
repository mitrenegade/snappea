//
//  CoordinateService.swift
//  VeggieTag
//
//  Created by Bobby Ren on 5/9/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(from other: CGPoint) -> CGFloat {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx*dx + dy*dy)
    }

    func translate(tx: CGFloat, ty: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + tx, y: self.y + ty)
    }
}

struct CoordinateService {
    static func pixelToCoord(imageSize: CGSize, point: CGPoint) -> NormalizedCoordinate {
        let x = point.x / imageSize.width
        let y = point.y / imageSize.height
        return NormalizedCoordinate(x: Double(x), y: Double(y))
    }

    static func coordToPixel(imageSize: CGSize, coordinate: NormalizedCoordinate) -> CGPoint {
        let x = CGFloat(coordinate.x) * imageSize.width
        let y = CGFloat(coordinate.y) * imageSize.height
        return CGPoint(x: x, y: y)
    }

    static func getValidCoordinatesFromPixels(imageSize: CGSize, start: CGPoint, end: CGPoint?) -> (NormalizedCoordinate, NormalizedCoordinate) {
        let endPoint = end ?? start
        var leftTop = CGPoint(x: min(start.x, endPoint.x), y: min(start.y, endPoint.y))
        var rightBottom = CGPoint(x: max(start.x, endPoint.x), y: max(start.y, endPoint.y))

        if rightBottom.distance(from: leftTop) < 10 {
            let center = CGPoint(x: (leftTop.x + rightBottom.x)/2, y: (leftTop.y + rightBottom.y)/2)
            leftTop = center.translate(tx: -20, ty: -20)
            rightBottom = center.translate(tx: 20, ty: 20)
        }
        
        return (pixelToCoord(imageSize: imageSize, point: leftTop),
                pixelToCoord(imageSize: imageSize, point: rightBottom))
    }
}
