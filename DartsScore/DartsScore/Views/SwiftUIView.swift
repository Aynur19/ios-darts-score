////
////  SwiftUIView.swift
////  DartsScore
////
////  Created by Aynur Nasybullin on 28.12.2023.
////
//
//import SwiftUI
//import Combine
//
//struct MessageBubble: View {
//    let text: String
//
//    @State private var offset: CurrentValueSubject<CGFloat, Never> = .init(0)
//    @State private var publisher: AnyPublisher<CGFloat, Never>
//
//    var body: some View {
//        HStack {
//            Spacer()
//            Text(text)
//                .foregroundColor(.white)
//                .padding()
//                // Add from here
//                .background(
//                    GeometryReader {
//                        GradientBackgroundView(
//                            offset: offset.value,
//                            height: $0.size.height
//                        )
//                    }
//                )
//                // To here
//                .clipShape(Capsule())
//                .onPreferenceChange(ViewOffsetKey2.self) {
//                    offset.send($0)
//                }
//        }
//    }
//    
//    private func GradientBackgroundView(offset: CGFloat, height: CGFloat) -> some View {
//        let screenBounds = UIScreen.main.bounds
//        let startY = offset / height
//        let endY = 1 + (screenBounds.height - offset - height) / height
//        return LinearGradient(
//           colors: [.purple, .blue],
//           startPoint: .init(x: 0, y: -startY),
//           endPoint: .init(x: 0, y: endY)
//        )
//        .frame(width: screenBounds.width, height: screenBounds.height)
//    }
//}
//
//struct ViewOffsetKey2: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value += nextValue()
//    }
//}
//
////struct SwiftUIView: View {
////    let messages = ["Hello", "Nice to meet you.", "My name is Toru Furuya.", "Do you know how to create a gradient background by scroll offset like Instagram does?", "If you want to get some ideas, please read my article through the end.", "I hope it will be helpful for you!", "Good luck 🤞"]
////
////        var body: some View {
////            ScrollView {
////                LazyVStack {
////                    ForEach(messages, id: \.self) {
////                        MessageBubble(text: $0)
////                    }
////                }
////            }
////        }
////}
////
////#Preview {
////    SwiftUIView()
////}
