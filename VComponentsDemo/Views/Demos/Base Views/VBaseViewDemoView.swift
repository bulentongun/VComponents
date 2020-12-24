//
//  VBaseViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Base View Demo View
struct VBaseViewDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Base View"
    
    @State private var navigationBarTitleIsLeading: Bool = true
    @State private var navigationBarHasLeadingItem: Bool = false
    @State private var navigationBarHasTrailingItem: Bool = false
    
    var viewType: VBaseViewType {
        switch navigationBarTitleIsLeading {
        case false: return .centerTitle()
        case true: return .leadingTitle()
        }
    }
}

// MARK:- Body
extension VBaseViewDemoView {
    var body: some View {
        VBaseView(
            viewType,
            title: Self.navigationBarTitle,
            leadingItem: leadingItem,
            trailingItem: trailingItem,
            content: { viewContent }
        )
    }
    
    private var viewContent: some View {
        ZStack(content: {
            VComponents.ColorBook.layer.edgesIgnoringSafeArea(.bottom)
            
            VStack(content: {
                VToggle(.setting(), isOn: $navigationBarTitleIsLeading, title: "Title is on left")
                
                VToggle(.setting(), isOn: $navigationBarHasLeadingItem, title: "Leading items")
                
                VToggle(.setting(), isOn: $navigationBarHasTrailingItem, title: "Trailing items")
            })
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(20)
            
                .font(.body)
        })
    }
    
    @ViewBuilder var leadingItem: some View {
        if navigationBarHasLeadingItem {
            HStack(content: {
                Text("Item")
            })
        }
    }
    
    @ViewBuilder var trailingItem: some View {
        if navigationBarHasTrailingItem {
            HStack(content: {
                Text("Item 1")
                Text("Item 2")
            })
        }
    }
}

// MARK:- Preview
struct VBaseViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseViewDemoView()
    }
}