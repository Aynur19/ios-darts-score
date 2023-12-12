//
//  HStepperView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 10.12.2023.
//

import SwiftUI

// original source: https://www.hackingwithswift.com/forums/100-days-of-swiftui/custom-stepper-view/13742
struct HStepperView<DataType, LabelViewType, DecrementViewType, IncrementViewType, DividerViewType>: View
where DataType: AdditiveArithmetic,
      DataType: Comparable,
      LabelViewType: View,
      DecrementViewType: View,
      IncrementViewType: View,
      DividerViewType: View {
    
    @Binding var value: DataType
    private let range: ClosedRange<DataType>
    private let step: DataType
    
    private let onDecrement: (() -> Void)?
    private let onIncrement: (() -> Void)?
    
    private let buttonSize: CGSize
    private let cornerRadius: CGFloat
    private let containerSize: CGSize
    private let tapAnimationDuration: Double = 0.3
    private let buttonCornerRadius: CGFloat = 8
    
    private let containerBackground: Color
    private let tappedBackground: Color
    private let onBoundMask: Color
    
    @ViewBuilder private var labelView: (DataType) -> LabelViewType
    @ViewBuilder private var decrementView: DecrementViewType
    @ViewBuilder private var incrementView: IncrementViewType
    @ViewBuilder private var dividerView: DividerViewType
    
    @State private var decrementTapped = false
    @State private var incrementTapped = false
    
    init(
        value: Binding<DataType>,
        range: ClosedRange<DataType>,
        step: DataType,
        onDecrement: (() -> Void)? = nil,
        onIncrement: (() -> Void)? = nil,
        buttonsCornerRadius: CGFloat = 8,
        buttonsContainerSize: CGSize = .init(width: 96, height: 32),
        buttonsContainerBackground: Color = .init(.systemGray5),
        tappedBackground: Color = .black.opacity(0.5),
        onBoundMask: Color = .black.opacity(0.5),
        @ViewBuilder labelView: @escaping (DataType) -> LabelViewType,
        @ViewBuilder decrementView: () -> DecrementViewType = { Image(systemName: "minus") },
        @ViewBuilder incrementView: () -> IncrementViewType = { Image(systemName: "plus") },
        @ViewBuilder dividerView: () -> DividerViewType = {
            Rectangle()
                .fill(Color(.systemGray3))
                .frame(width: 1.5, height: 16)
        }
    ) {
        _value = value
        self.range = range
        self.step = step
        
        self.onDecrement = onDecrement
        self.onIncrement = onIncrement
        
        self.cornerRadius = buttonsCornerRadius
        self.containerSize = buttonsContainerSize
        self.buttonSize = .init(width: buttonsContainerSize.width.half,
                                height: buttonsContainerSize.height)
        
        self.containerBackground = buttonsContainerBackground
        self.tappedBackground = tappedBackground
        self.onBoundMask = onBoundMask
        
        self.labelView = labelView
        self.decrementView = decrementView()
        self.incrementView = incrementView()
        self.dividerView = dividerView()
    }
    
    var body: some View {
        HStack {
            labelView(value)
            Spacer()
            
            ZStack {
                containerBackground
                
                HStack(spacing: .zero) {
                    decrementButton
                    incrementButton
                }
                
                dividerView
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(width: containerSize.width, height: containerSize.height)
            .onTapGesture { touchPoint in
                onTapped(at: touchPoint)
            }
            .contentShape(Rectangle())
        }
        .onAppear { onAppeared() }
    }
    
    private func onAppeared() {
        if value < range.lowerBound {
            value = range.lowerBound
        } else if value > range.upperBound {
            value = range.upperBound
        }
    }
    
    private func onTapped(at touchPoint: CGPoint) {
        if touchPoint.x < .zero || touchPoint.y < .zero { return }
        
        if touchPoint.x - 10 > containerSize.width
            || touchPoint.y - 10 > containerSize.height { return }
        
        if touchPoint.x < containerSize.width.half {
            decrement()
        } else {
            increment()
        }
    }
    
    private func decrement() {
        if value <= range.lowerBound { return }
        
        withAnimation(.linear(duration: tapAnimationDuration)) {
            decrementTapped.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + tapAnimationDuration) {
                decrementTapped.toggle()
            }
        }
        
        if value - step >= range.lowerBound {
            value -= step
        } else {
            value = range.lowerBound
        }
        
        if let onDecrement = onDecrement {
            onDecrement()
        }
    }
    
    private func increment() {
        if value >= range.upperBound { return }
        
        withAnimation(.linear(duration: tapAnimationDuration)) {
            incrementTapped.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + tapAnimationDuration) {
                incrementTapped.toggle()
            }
        }
        
        if value + step <= range.upperBound {
            value += step
        } else {
            value = range.upperBound
        }
        
        if let onIncrement = onIncrement {
            onIncrement()
        }
    }
    
    private var onLowerBound: Bool { value == range.lowerBound }
    
    private var onUpperBound: Bool { value == range.upperBound }
    
    private var decrementButton: some View {
        decrementView
            .frame(width: buttonSize.width, height: buttonSize.height)
            .mask { onLowerBound ? onBoundMask : .black }
            .background { decrementTapped ? tappedBackground : .clear }
            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRadius))
    }

    private var incrementButton: some View {
        incrementView
            .frame(width: buttonSize.width, height: buttonSize.height)
            .mask { onUpperBound ? onBoundMask : .black }
            .background { incrementTapped ? tappedBackground : .clear }
            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRadius))
    }
}

struct TestCustomStepperView: View {
    @State private var value = 0
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("\(value.formatted())", value: $value, in: -5...5, step: 1)
                }
                
                Section {
                    HStepperView(
                        value: $value,
                        range: -5...5,
                        step: 1,
                        labelView: { value in
                            Text("Current value: \(value)")
                        }
                    )
                }
                
                Section {
                    HStepperView(
                        value: $value,
                        range: -5...5,
                        step: 1,
                        onDecrement: { print("onDecrement()") },
                        onIncrement: { print("onIncrement()") },
                        buttonsCornerRadius: 16,
                        buttonsContainerSize: .init(width: 100, height: 50),
                        buttonsContainerBackground: .orange,
                        tappedBackground: .black.opacity(0.25),
                        onBoundMask: .black.opacity(0.25),
                        labelView: { value in
                            Text("Current value: \(value)")
                                .foregroundStyle(Color.orange)
                        },
                        decrementView: {
                            Image(systemName: "minus")
                                .foregroundStyle(Color.black)
                        },
                        incrementView: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.black)
                        },
                        dividerView: {
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: 1.5, height: 34)
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    TestCustomStepperView()
}
