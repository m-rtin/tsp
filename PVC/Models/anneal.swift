//
//  anneal.swift
//  PVC
//
//  Created by Martin Voigt on 04.01.21.
//

import Foundation


class Anneal {
    var coordinates: [(xCoord: CGFloat, yCoord: CGFloat)]
    var temperature: Double
    
    var currentPathDistance: Double
    var currentSolution: [Node]
    
    var iteration: Int = 0
    
    var bestPathDistance: Double = 10E10
    var bestSolution: [Node] = [Node]()
    
    var nodes: [Node] = [Node]()
    var numberOfNodes: Int
    
    init(coordinates: [(CGFloat, CGFloat)], temperature: Double) {
        self.coordinates = coordinates
        self.temperature = temperature
        for i in Array(0...self.coordinates.count-1) {
            self.nodes.append(Node(index: i, xCoord: self.coordinates[i].xCoord, yCoord: self.coordinates[i].yCoord))
        }
        self.nodes.shuffle()
        self.numberOfNodes = self.nodes.count
        self.currentSolution = self.nodes
        self.currentPathDistance = distanceOfPath(path: self.currentSolution)
    }
    
    func reset(ready: inout Bool) {
        self.coordinates = createRandomClusterPoints(widthLimit: 600, heightLimit: 600)
        self.temperature = 125
        
        self.bestPathDistance = 10E10
        self.bestSolution = [Node]()
        
        self.nodes = [Node]()
        
        for i in Array(0...self.coordinates.count-1) {
            self.nodes.append(Node(index: i, xCoord: self.coordinates[i].xCoord, yCoord: self.coordinates[i].yCoord))
        }
        self.nodes.shuffle()
        self.numberOfNodes = self.nodes.count
        ready = false
        self.currentSolution = self.nodes.shuffled()
        self.currentPathDistance = distanceOfPath(path: self.currentSolution)
        self.iteration = 0
    }
    
    // Calculate initial solution with a greedy algorithm
    func getInitialSolution() -> [Node] {
        var currentNode = self.nodes.randomElement()
        var solution: [Node] = [currentNode!]
        
        var freeNodes: Set = Set(self.nodes)
        freeNodes.remove(currentNode!)
        
        while freeNodes.count > 0 {
            var minimumDistance = 10e10
            var newNode = Node(index: -1, xCoord: 0, yCoord: 0)
            for freeNode in freeNodes {
                let distance = calculateDistanceBetweenNodes(aNode: freeNode, anotherNode: currentNode!)
                if distance < minimumDistance {
                    minimumDistance = distance
                    newNode = freeNode
                }
            }
            freeNodes.remove(newNode)
            solution.append(newNode)
            currentNode = newNode
        }
        
        self.currentPathDistance = distanceOfPath(path: solution)
        self.currentSolution = solution
        
        if self.currentPathDistance < self.bestPathDistance {
            self.bestPathDistance = self.currentPathDistance
            self.bestSolution = solution
        }
        return solution
    }
    
    // One simulated annealing step
    func makeAnnealingStep(ready: inout Bool) -> [Node] {
        while self.temperature >= 1e-8 {
            var candidate: [Node] = self.currentSolution
            if self.iteration == 0 {
                candidate = self.getInitialSolution()
            }
            self.iteration += 1
            
            // 2 opt
            let l = Int.random(in: 2..<self.numberOfNodes)
            let i = Int.random(in: 0..<self.numberOfNodes - l + 1)
            
            let reversedPart = Array(self.currentSolution[i..<(i + l)].reversed())
            
            for index in i..<(i+l) {
                candidate[index] = reversedPart[index-i]
            }
            
            let updateHappend = self.accept(candidate: candidate)
            
            // the temperature should be a decreasing sequence
            self.temperature *= 1 - 0.01
            
            // there was an update of the current solution
            if updateHappend {
                return self.currentSolution
            }
        }
        
        // Return best solution at the end
        ready = true
        self.currentSolution = self.bestSolution
        return self.bestSolution
    }
    
    // Selection step of simulated annealing
    func accept(candidate: [Node]) -> Bool {
        let candidatePathDistance = distanceOfPath(path: candidate)
        
        if candidatePathDistance < self.currentPathDistance {
            self.currentPathDistance = candidatePathDistance
            self.currentSolution = candidate
            
            if candidatePathDistance < self.bestPathDistance {
                self.bestPathDistance = candidatePathDistance
                self.bestSolution = candidate
            }
            return true
        } else {
            // Boltzman
            if Double.random(in: 0...1) < exp(-abs(candidatePathDistance - self.currentPathDistance) / self.temperature) {
                self.currentSolution = candidate
                self.currentPathDistance = candidatePathDistance
                return true
            }
        }
        return false
    }
    
    func getFirstNode() -> CGPoint {
        return CGPoint(x: self.currentSolution.last!.xCoord, y: self.currentSolution.last!.yCoord)
    }
    
    func getLastNode() -> CGPoint {
        return CGPoint(x: self.currentSolution.first!.xCoord, y: self.currentSolution.first!.yCoord)
    }
    
    // Get all the current of the nodes in the best solution (in the right order)
    func getCoordinatesAsPoints() -> [CGPoint] {
        var pointArray: [CGPoint] = [CGPoint]()
        for node in self.currentSolution {
            pointArray.append(CGPoint(x: node.xCoord, y: node.yCoord))
        }
        return pointArray
    }
}
