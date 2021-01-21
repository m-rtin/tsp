//
//  ContentView.swift
//  PVC
//
//  Created by Martin Voigt on 04.01.21.
//

import SwiftUI


struct windowSize {
    let minWidth : CGFloat = 600
    let maxWidth : CGFloat = 600
    
    let minHeight : CGFloat = 600
    let maxHeight : CGFloat = 600
}


struct ContentView : View {
    var body: some View {
        pointView(anneal: Anneal(coordinates: createRandomClusterPoints(widthLimit: 600, heightLimit: 600), temperature: 125.0))
            .frame(minWidth: windowSize().minWidth, minHeight: windowSize().minHeight)
            .frame(maxWidth: windowSize().maxWidth, maxHeight: windowSize().maxHeight)
    }
    
    
}

