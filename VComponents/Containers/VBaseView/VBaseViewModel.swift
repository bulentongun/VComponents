//
//  VBaseViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base View Model
public struct VBaseViewModel {
    public let layout: Layout
    public let fonts: Fonts
    
    public init(
        layout: Layout = .init(),
        fonts: Fonts = .init()
    ) {
        self.layout = layout
        self.fonts = fonts
    }
}

// MARK:- Colors
extension VBaseViewModel {
    public struct Layout {
        public let titleAlignment: TitleAlignment
        public let itemSpacing: CGFloat
        
        public init(
            titleAlignment: TitleAlignment = .leading,
            itemSpacing: CGFloat = 10
        ) {
            self.titleAlignment = titleAlignment
            self.itemSpacing = itemSpacing
        }
    }
}

extension VBaseViewModel.Layout {
    public enum TitleAlignment {
        case leading
        case center
    }
}

// MARK:- Fonts
extension VBaseViewModel {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.navigationBarTitle
        ) {
            self.title = title
        }
    }
}
