//
//  VSpinnerModelContinous.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Model Continous
public struct VSpinnerModelContinous {
    public let behavior: Behavior
    public let layout: Layout
    public let color: Color
    
    public init(
        behavior: Behavior = .init(),
        layout: Layout = .init(),
        color: Color = ColorBook.accent
    ) {
        self.behavior = behavior
        self.layout = layout
        self.color = color
    }
}

// MARK:- Behavior
extension VSpinnerModelContinous {
    public struct Behavior {
        public let animation: Animation
        
        public init(
            animation: Animation = .linear(duration: 0.75)
        ) {
            self.animation = animation
        }
    }
}

// MARK:- Layout
extension VSpinnerModelContinous {
    public struct Layout {
        public let dimension: CGFloat
        public let legth: CGFloat
        public let thickness: CGFloat
        
        public init(
            dimension: CGFloat = 15,
            legth: CGFloat = 0.75,
            thickness: CGFloat = 2
        ) {
            self.dimension = dimension
            self.legth = legth
            self.thickness = thickness
        }
    }
}
