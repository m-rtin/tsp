//
//  node.swift
//  PVC
//
//  Created by Martin Voigt on 18.01.21.
//

import Foundation
import SwiftUI
import GameplayKit


struct Node: Hashable {
    var index: Int
    var xCoord: CGFloat
    var yCoord: CGFloat
    
    init(index: Int, xCoord: CGFloat, yCoord: CGFloat) {
        self.index = index
        self.xCoord = xCoord
        self.yCoord = yCoord
    }
}


func calculateDistanceBetweenNodes(aNode: Node, anotherNode: Node) -> Double {
    return Double(sqrt(pow(aNode.xCoord - anotherNode.xCoord, 2) + pow(aNode.yCoord - anotherNode.yCoord, 2)))
}

// Fitness function: distance if we follow the whole path
func distanceOfPath(path: [Node]) -> Double {
    if path.count == 0 {
        return 0
    }
    var distance: Double = 0.0
    
    for index in 1..<path.count {
        distance += calculateDistanceBetweenNodes(aNode: path[index], anotherNode: path[index-1])
    }
    distance += calculateDistanceBetweenNodes(aNode: path[path.count-1], anotherNode: path[0])
    return distance
}

func nodesToCGPoints(nodes: [Node]) -> [CGPoint] {
    var points: [CGPoint] = [CGPoint]()
    for node in nodes {
        points.append(CGPoint(x: node.xCoord, y: node.yCoord))
    }
    return points
}

func createRandomPoints(numberOfPoints: Int, widthLimit: Int, heightLimit: Int) -> [(CGFloat, CGFloat)] {
    var coordinates: [(CGFloat, CGFloat)] = [(CGFloat, CGFloat)]()
    for _ in 0..<numberOfPoints {
        coordinates.append(
            (CGFloat(Int.random(in: 30..<widthLimit-30)),
             CGFloat(Int.random(in: 10..<heightLimit-90)))
        )
    }
    return coordinates
}

// Quick and dirty way to create three clusters
func createRandomClusterPoints(widthLimit: Int, heightLimit: Int) -> [(CGFloat, CGFloat)] {
    var coordinates: [(CGFloat, CGFloat)] = [(CGFloat, CGFloat)]()
    
    // bottom left
    let xDistribution1 = GKGaussianDistribution(lowestValue: 15, highestValue: widthLimit-350)
    let yDistribution1 = GKGaussianDistribution(lowestValue: 300, highestValue: heightLimit-130)
    
    // bottom right
    let xDistribution2 = GKGaussianDistribution(lowestValue: 300, highestValue: widthLimit-30)
    let yDistribution2 = GKGaussianDistribution(lowestValue: 300, highestValue: heightLimit-130)
    
    // upper middle
    let xDistribution3 = GKGaussianDistribution(lowestValue: 100, highestValue: widthLimit-150)
    let yDistribution3 = GKGaussianDistribution(lowestValue: 0, highestValue: heightLimit-400)
    
    
    for i in 0..<100 {
        if i <= 25 {
            let randomX = xDistribution1.nextInt()
            let randomY = yDistribution1.nextInt()
            coordinates.append(
                (CGFloat(randomX),
                 CGFloat(randomY))
            )
            
        } else if i <= 50 {
            let randomX = xDistribution2.nextInt()
            let randomY = yDistribution2.nextInt()
            coordinates.append(
                (CGFloat(randomX),
                 CGFloat(randomY))
            )
            
        } else if i <= 75{
            let randomX = xDistribution3.nextInt()
            let randomY = yDistribution3.nextInt()
            coordinates.append(
                (CGFloat(randomX),
                 CGFloat(randomY))
            )
        }
    }
    return coordinates
    
}
