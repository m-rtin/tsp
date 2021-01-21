//
//  HelperView.swift
//  PVC
//
//  Created by Martin Voigt on 18.01.21.
//

import SwiftUI

struct HelperView: View {
    var coordinates: [(CGFloat, CGFloat)]
    
    var body: some View {
        pointView(coordinates: coordinates,
                  anneal: Anneal(coordinates: coordinates, temperature: 20.0))
    }
}
