//
//  CGPointExtension.swift
//  UEBubblePicker
//
//  Created by Iuri Gil Claro Chiba on 30/05/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit

internal extension CGPoint {
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    static func /(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    static func *(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    static func /(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    
    static func +(left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x + right.width, y: left.y + right.height)
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        let distance = self - point
        return sqrt(distance.x * distance.x + distance.y + distance.y)
    }
    
    init(averageOf points: CGPoint...) {
        let sum = points.reduce(CGPoint.zero, +)
        self = sum/CGFloat(points.count)
    }

    init(interpolate point1: CGPoint, with point2: CGPoint, weight: CGFloat) {
        let sum = point1 * (1 - weight) + point2 * weight
        self = sum
    }
    
    mutating func constrain(by rect: CGRect) {
        x = max(x, rect.minX)
        x = min(x, rect.maxX)
        y = max(y, rect.minY)
        y = min(y, rect.maxY)
    }
    
    func convertToVector() -> CGVector {
        return CGVector(dx: x, dy: y)
    }
}
