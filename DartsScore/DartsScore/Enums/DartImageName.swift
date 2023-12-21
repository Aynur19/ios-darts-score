//
//  DartImageName.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 12.12.2023.
//

import SwiftUI

enum DartImageName: String {
    case dart1 = "Dart 1"
    case dart2 = "Dart 2"
    case dart3 = "Dart 3"
    case dart4 = "Dart 4"
    case dart5 = "Dart 5"
    case dart6 = "Dart 6"
    case dart7 = "Dart 7"
    
    case dartFlipH1 = "Dart Flip H 1"
    case dartFlipH2 = "Dart Flip H 2"
    
    case dart1Rotate180 = "Dart Rotate 180 1"
    
    @ViewBuilder
    func image(size: CGFloat) -> some View {
        if self == .dart1Rotate180 {
            rotatedImage(size: size, degrees: 180)
        } else if self == .dartFlipH1 || self == .dartFlipH2 {
            flippedImage(size: size, axes: .horizontal)
        } else {
            resizedImage(size: size)
        }
    }
    
    private func resizedImage(size: CGFloat) -> some View {
        Image(self.rawValue)
            .resizable()
            .frame(width: size, height: size)
    }
    
    private func rotatedImage(size: CGFloat, degrees: Double) -> some View {
        Image(self.rawValue)
            .resizable()
            .rotationEffect(.degrees(degrees))
            .frame(width: size, height: size)
    }
    
    private func flippedImage(size: CGFloat, axes: Axis) -> some View {
        Image(self.rawValue)
            .resizable()
            .scaleEffect(x: axes == .horizontal ? -1 : 1,
                         y: axes == .vertical ? -1 : 1)
            .frame(width: size, height: size)
    }
}

//private struct TestDartImageView: View {
//    var body: some View {
//        VStack {
//            ForEach(AppConstants.dartImageNamesData, id: \.self) { item in
//                item.image(size: 32)
//            }
//        }
//    }
//}
//
//#Preview {
//    TestDartImageView()
//}
