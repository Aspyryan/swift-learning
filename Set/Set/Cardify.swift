//
//  Cardify.swift
//  Set
//
//  Created by Jasper on 28/11/2022.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isSelected: Bool
    var isCorrectelyMatched: Bool?
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            shape.fill(.white)
            if isSelected {
                if let potentialMatch = isCorrectelyMatched {
                    if potentialMatch == true {
                        shape.fill(.green).opacity(0.4)
                    } else {
                        shape.fill(.red).opacity(0.4)
                    }
                }
                shape.strokeBorder(lineWidth: 3).foregroundColor(.yellow)
            } else {
                shape.strokeBorder(lineWidth: 2).foregroundColor(.black)
            }
            content
        }
    }
}

extension View {
    func cardify(isSelected: Bool, isCorrectelyMatched: Bool?) -> some View {
        self.modifier(Cardify(isSelected: isSelected, isCorrectelyMatched: isCorrectelyMatched))
    }
}
