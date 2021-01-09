//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker
public struct VSegmentedPicker<RowContent>: View where RowContent: View {
    // MARK: Properties
    private let model: VSegmentedPickerModel
    
    @Binding private var selectedIndex: Int
    
    private let state: VSegmentedPickerState
    @State private var pressedIndex: Int? = nil
    private func rowState(for index: Int) -> VSegmentedPickerRowState { .init(
        isEnabled: !state.isDisabled && !disabledIndexes.contains(index),
        isPressed: pressedIndex == index
    ) }
    
    private let title: String?
    private let subtitle: String?
    
    private let data: [RowContent]
    private let disabledIndexes: Set<Int>
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        views: [RowContent],
        disabledIndexes: Set<Int> = .init()
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.title = title
        self.subtitle = subtitle
        self.data = views
        self.disabledIndexes = disabledIndexes
    }
    
    public init<S>(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        titles: [S],
        disabledIndexes: Set<Int> = .init()
    )
        where
            RowContent == VGenericTitleContentView<S>,
            S: StringProtocol
    {
        self.init(
            model: model,
            selectedIndex: selectedIndex,
            state: state,
            title: title,
            subtitle: subtitle,
            views: titles.map { VGenericTitleContentView(title: $0, color: model.colors.textColor(for: state), font: model.fonts.rows) },
            disabledIndexes: disabledIndexes
        )
    }
    
    public init<Option>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Option>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledIndexes: Set<Int> = .init()
    )
        where
            RowContent == Option.PickerSymbol,
            Option: VPickerEnumerableOption
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Option(rawValue: $0)! }
            ),
            state: state,
            title: title,
            subtitle: subtitle,
            views: Option.allCases.map { $0.pickerSymbol },
            disabledIndexes: disabledIndexes
        )
    }
    
    public init<S, Option>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Option>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledIndexes: Set<Int> = .init()
    )
        where
            RowContent == VGenericTitleContentView<Option.S>,
            Option: VPickerTitledEnumerableOption,
            Option.S == S
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Option(rawValue: $0)! }
            ),
            state: state,
            title: title,
            subtitle: subtitle,
            views: Option.allCases.map { VGenericTitleContentView(title: $0.pickerTitle, color: model.colors.textColor(for: state), font: model.fonts.rows) },
            disabledIndexes: disabledIndexes
        )
    }
}

// MARK:- Body
public extension VSegmentedPicker {
    var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleSpacing, content: {
            titleView
            pickerView
            subtitleView
        })
    }
    
    private var pickerView: some View {
        ZStack(alignment: .leading, content: {
            background
            indicator
            rows
            dividers
        })
            .frame(height: model.layout.height)
            .cornerRadius(model.layout.cornerRadius)
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VGenericTitleContentView(
                title: title,
                color: model.colors.titleColor(for: state),
                font: model.fonts.title,
                alignment: .leading
            )
                .padding(.horizontal, model.layout.titlePaddingHor)
                .opacity(model.colors.foregroundOpacity(state: state))
        }
    }
    
    @ViewBuilder private var subtitleView: some View {
        if let subtitle = subtitle, !subtitle.isEmpty {
            VGenericTitleContentView(
                title: subtitle,
                color: model.colors.subtitleColor(for: state),
                font: model.fonts.subtitle,
                alignment: .leading,
                lineLimit: nil
            )
                .padding(.horizontal, model.layout.titlePaddingHor)
                .opacity(model.colors.foregroundOpacity(state: state))
        }
    }
    
    private var background: some View {
        model.colors.backgroundColor(for: state)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: model.layout.indicatorCornerRadius)
            .padding(model.layout.indicatorPadding)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(selectedIndex))
            .animation(model.behavior.selectionAnimation)
            
            .foregroundColor(model.colors.indicatorColor(for: state))
            .shadow(
                color: model.colors.indicatorShadowColor(for: state),
                radius: model.layout.indicatorShadowRadius,
                y: model.layout.indicatorShadowOffsetY
            )
    }
    
    private var rows: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                VBaseButton(
                    isDisabled: state.isDisabled || disabledIndexes.contains(i),
                    action: { selectedIndex = i },
                    onPress: { pressedIndex = $0 ? i : nil },
                    content: {
                        data[i]
                            .padding(model.layout.actualRowContentPadding)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            .font(model.fonts.rows)
                            .opacity(foregroundOpacity(for: i))
                            
                            .readSize(onChange: { rowWidth = $0.width })
                    }
                )
            })
        })
    }
    
    private var dividers: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                Spacer()
                
                if i <= data.count-2 {
                    Divider()
                        .opacity(dividerOpacity(for: i))
                        .frame(height: model.layout.dividerHeight)
                }
            })
        })
    }
}

// MARK:- State Indication
private extension VSegmentedPicker {
    var indicatorScale: CGFloat {
        switch selectedIndex {
        case pressedIndex: return model.layout.indicatorPressedScale
        case _: return 1
        }
    }
    
    func foregroundOpacity(for index: Int) -> Double {
        model.colors.foregroundOpacity(state: rowState(for: index))
    }
    
    func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selectedIndex
        
        switch isBeforeIndicator {
        case false: return index - selectedIndex < 1 ? 0 : 1
        case true: return selectedIndex - index <= 1 ? 0 : 1
        }
    }
}

// MARK:- Preview
struct VSegmentedPicker_Previews: PreviewProvider {
    @State private static var selection: Options = .one
    private enum Options: Int, CaseIterable, VPickerTitledEnumerableOption {
        case one
        case two
        case three
        
        var pickerTitle: String {
            switch self {
            case .one: return "One"
            case .two: return "Two"
            case .three: return "Three"
            }
        }
    }
    
    static var previews: some View {
        VSegmentedPicker(selection: $selection, disabledIndexes: [1])
            .padding(20)
    }
}
