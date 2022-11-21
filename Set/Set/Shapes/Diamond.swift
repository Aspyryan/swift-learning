//
//  Diamond.swift
//  Set
//
//  Created by Gast Gebruiker on 21/11/2022.
//

import SwiftUI

struct Diamond: Shape {
    let filling: SetFilling
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let top = CGPoint(x: rect.midX, y: rect.midY + (rect.width / 4))
        let bottom = CGPoint(x: rect.midX, y: rect.midY - (rect.width / 4))
        let left = CGPoint(x: rect.midX - (rect.width / 2), y: rect.midY)
        let right = CGPoint(x: rect.midX + (rect.width / 2), y: rect.midY)
        
        p.move(to: top)
        p.addLine(to: left)
        p.addLine(to: bottom)
        p.addLine(to: right)
        p.addLine(to: top)
        
        return p
    }
}
