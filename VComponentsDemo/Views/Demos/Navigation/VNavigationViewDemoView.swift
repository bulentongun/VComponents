//
//  VNavigationViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Navigation View and Base View Demo View
struct VNavigationViewDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Navigation View"
}

// MARK:- Body
extension VNavigationViewDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            VStack(spacing: 20, content: {
                Text("Navigation View should only ever be used on a root view. Continue?")
                    .multilineTextAlignment(.center)
                
                VSecondaryButton(
                    action: { SceneDelegate.setRootView(to: NavigationDemoView1()) },
                    title: "Start Demo"
                )
            })
                .padding(10)
        })
    }
}

// MARK:- Walkthrough
private struct NavigationDemoView1: View {
    var body: some View {
        VNavigationView(content: {
            VBaseView(title: "Home", content: {
                NavigationDemoView(
                    color: .red,
                    instruction: [
                        "You are on Home page",
                        "From here you can navigate to Details"
                    ].joined(separator: "\n\n"),
                    destination: NavigationDemoView2()
                )
            })
        })
    }
}

private struct NavigationDemoView2: View {
    var body: some View {
        VBaseView(title: "Details", content: {
            NavigationDemoView(
                color: .green,
                instruction: [
                    "You are on Details page",
                    "From here you can navigate back, or go futher to Additional Details"
                ].joined(separator: "\n\n"),
                destination: NavigationDemoView3()
            )
        })
    }
}

private struct NavigationDemoView3: View {
    var body: some View {
        VBaseView(title: "Additional Details", content: {
            NavigationDemoView(
                color: .green,
                instruction: [
                    "You are on Additional Details page",
                    "From here you can navigate back, or jump to new the navigation stack"
                ].joined(separator: "\n\n"),
                action: { SceneDelegate.setRootView(to: HomeView()) }
            )
        })
    }
}

// MARK:- Navigation Demo View
private struct NavigationDemoView<Destination>: View where Destination: View {
    // MARK: Properties
    private let color: Color
    
    private let instruction: String
    
    private let action: ActionType
    enum ActionType {
        case navigation(_ destination: Destination)
        case custom(_ action: () -> Void)
    }
    
    // MARK: Initializers
    init(
        color: Color,
        instruction: String,
        destination: Destination
    ) {
        self.color = color
        self.instruction = instruction
        self.action = .navigation(destination)
    }

    init(
        color: Color,
        instruction: String,
        action: @escaping () -> Void
    )
        where Destination == Never 
    {
        self.color = color
        self.instruction = instruction
        self.action = .custom(action)
    }
}
    
extension NavigationDemoView {
    var body: some View {
        ZStack(content: {
            color
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)
            
            Text(instruction)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .multilineTextAlignment(.center)
            
            switch action {
            case .navigation(let desitnation):
                NavigationLink(destination: desitnation, label: {
                    VSecondaryButton(action: {}, title: "Continue")
                        .allowsHitTesting(false)
                })
                
            case .custom(let action):
                VSecondaryButton(action: action, title: "Continue")
            }
        })
    }
}

// MARK:- Preview
struct VNavigationViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationViewDemoView()
    }
}
