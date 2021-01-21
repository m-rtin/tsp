//
//  pointView.swift
//  PVC
//
//  Created by Martin Voigt on 18.01.21.
//

import SwiftUI
import Combine


struct pointView: View {
    
    var anneal: Anneal
    @State private var solutionArray = [Node]()
    @State private var cancelable : AnyCancellable?
    @State private var ready = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    anneal.reset(ready: &ready)
                    solutionArray = anneal.nodes
                }, label: {
                    Text("Generate new points")
                })
                
                Button(action: {
                    cancelable = Timer.publish(
                        every: 0.2,
                        on: RunLoop.main,
                        in: RunLoop.Mode.default
                    ).autoconnect().sink { (Date) in
                        solutionArray = anneal.makeAnnealingStep(ready: &ready)
                        if ready {
                            self.cancelable?.cancel()
                        }
                    }
                }, label: {
                    Text("Start Simulated Annealing")
                })
                
                Spacer()
                
                HStack {
                    Text("T: \(anneal.temperature)").foregroundColor(Color.gray)
                    Text("i: \(anneal.iteration)").foregroundColor(Color.gray)
                }
            }.padding()
            
            
            ZStack {
                Color.white
                Path { path in
                    path.move(to: anneal.getFirstNode())
                    path.addLines(anneal.getCoordinatesAsPoints())
                    path.addLine(to: anneal.getFirstNode())
                    path.addLine(to: anneal.getLastNode())
                }
                .stroke(ready ? Color.green : Color.blue, lineWidth: ready ? 2 : 1)
                
                ForEach(0..<anneal.coordinates.count) { i in
                    Text(String(i))
                        .foregroundColor(.white)
                        .font(.footnote)
                        .frame(width: 18, height: 18, alignment: .center)
                        .background(ready ? Circle().fill(Color.green) : Circle().fill(Color.blue))
                        .position(CGPoint(x: anneal.coordinates[i].xCoord,
                                          y: anneal.coordinates[i].yCoord))
                }
            }
            SolutionView(solutionNodes: solutionArray, anneal: anneal, ready: $ready)
                .padding()
        }
        
    }
}

