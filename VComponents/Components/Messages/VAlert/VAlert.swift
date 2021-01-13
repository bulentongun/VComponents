//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert
public struct VAlert<Content> where Content: View {
    // MARK: Properties
    public var model: VAlertModel = .init()
    public var dialogType: VAlertDialogType
    public var title: String?
    public var description: String?
    public var content: (() -> Content)?
    public var disappearAciton: (() -> Void)? = nil
    
    // MARK: Initializers
    public init(
        model: VAlertModel = .init(),
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content,
        onDisappear disappearAciton: (() -> Void)? = nil
    ) {
        self.model = model
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = content
        self.disappearAciton = disappearAciton
    }
    
    public init(
        model: VAlertModel = .init(),
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        onDisappear disappearAciton: (() -> Void)? = nil
    )
        where Content == Never
    {
        self.model = model
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = nil
        self.disappearAciton = disappearAciton
    }
}

// MARK:- Extension
public extension View {
    func vAlert<Content>(
        isPresented: Binding<Bool>,
        alert: @escaping () -> VAlert<Content>
    ) -> some View
        where Content: View
    {
        ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                VModalVCRepresentable(
                    isPresented: isPresented,
                    content: _VAlert(isPresented: isPresented, alert: alert()),
                    blinding: alert().model.colors.blinding.edgesIgnoringSafeArea(.all)
                )
            }
        })
    }
}
