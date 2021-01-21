//
//  SolutionView.swift
//  PVC
//
//  Created by Martin Voigt on 18.01.21.
//

import SwiftUI

struct SolutionView: View {
    
    var solutionNodes: [Node]
    var anneal: Anneal
    @Binding var ready: Bool
    
    var body: some View {
        
        HStack {
            Text("Fitness of current solution: \(distanceOfPath(path: solutionNodes))")
            Spacer()
            ready ? Text("Fitness of best solution: \(distanceOfPath(path: anneal.bestSolution))").foregroundColor(Color.green) : Text("Fitness of best solution: \(distanceOfPath(path: anneal.bestSolution))")
        }
        
    }
}
