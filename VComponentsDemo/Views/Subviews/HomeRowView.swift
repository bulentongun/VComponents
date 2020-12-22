//
//  HomeRowView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK:- Home Row View
struct HomeRowView<Content>: View where Content: View {
    // MARK: Properties
    private let title: String
    private let destination: Content
    
    private let showSeparator: Bool
    
    // MARK: Initalizers
    init(
        title: String,
        destination: Content,
        showSeparator: Bool = true
    ) {
        self.title = title
        self.destination = destination
        self.showSeparator = showSeparator
    }
}

// MARK:- Body
extension HomeRowView {
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            NavigationLink(destination: destination, label: {
                HStack(content: {
                    Text(title)
                        .foregroundColor(VComponents.ColorBook.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .opacity(0.5)
                })
            })
            
            if showSeparator {
                Divider()
                    .padding(.vertical, 10)
            }
        })
    }
}

// MARK:- Preview
struct HomeRowView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_Previews.previews
    }
}
