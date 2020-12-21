//
//  VSpinnerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Spinner Demo View
struct VSpinnerDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Spinner"
}

// MARK:- Body
extension VSpinnerDemoView {
    var body: some View {
        VLazyList(content: {
            spinners
        })
            .navigationTitle(Self.sceneTitle)
            .background(Color.blue)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    private var spinners: some View {
        VStack(content: {
            RowView(type: .titled("Continous"), titleColor: .white, content: {
                VSpinner(type: .continous())
            })
            
            RowView(type: .titled("Dashed"), titleColor: .white, content: {
                VSpinner(type: .dashed())
            })
        })
    }
}

// MARK:- Descriptions
private extension VSpinnerType {
    var description: String {
        switch self {
        case .continous: return "Continous"
        case .dashed: return "Dashed"
        }
    }
}

// MARK: Preview
struct VSpinnerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDemoView()
    }
}
