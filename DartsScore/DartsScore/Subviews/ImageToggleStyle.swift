//
//  ImageToggleStyle.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 10.12.2023.
//

import SwiftUI

struct ImageToggleStyle<ButtonType>: ToggleStyle
where ButtonType: View{
    
    let buttonChange: (Bool) -> ButtonType
    let backgroundChange: (Bool) -> Color

    let frameSize: CGSize
    let cornerRadius: CGFloat
    
    init(
        frameSize: CGSize = .init(width: 50, height: 32),
        cornerRadius: CGFloat = 30,
        buttonChange: @escaping (Bool) -> ButtonType = { isOn in
            Image(systemName: isOn ? "checkmark" : "xmark")
        },
        backgroundChange: @escaping (Bool) -> Color = { isOn in
            isOn ? .green : Color(.systemGray4)
        }
    ) {
        self.frameSize = frameSize
        self.cornerRadius = cornerRadius
        self.buttonChange = buttonChange
        self.backgroundChange = backgroundChange
    }
 
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            toggleView(configuration)
        }
    }
    
    private func toggleView(_ configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(backgroundChange(configuration.isOn))
            .overlay {
                buttonChange(configuration.isOn)
                    .offset(x: configuration.isOn ? xOffset : -xOffset)

            }
            .frame(width: frameSize.width, height: frameSize.height)
            .onTapGesture {
                withAnimation(.spring()) {
                    configuration.isOn.toggle()
                }
            }
    }
    
    private var xOffset: CGFloat {
        (frameSize.width - frameSize.height).half
    }
}

private struct TestImageToggleStyleView: View {
    let question = "Some question..."
    @State private var isOn = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            HStack {
                Text(question)
                Spacer()
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        ImageToggleStyle { isOn in
                            Circle()
                                .fill(Palette.btnPrimary)
                                .overlay {
                                    Image(systemName: isOn ? "checkmark" : "xmark")
                                        .foregroundStyle(Palette.btnPrimaryText)
                                }
                                .padding(2)
                        } backgroundChange: { isOn in
                            isOn ? Palette.btnPrimary.opacity(0.5) : Color(.systemGray4)
                        }
                    )
            }
        }
    }
}

#Preview {
    TestImageToggleStyleView()
}
