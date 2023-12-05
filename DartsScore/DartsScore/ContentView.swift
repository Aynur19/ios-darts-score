//
//  ContentView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct ContentView: View {
////    struct CustomWheelPickerView_Previews: PreviewProvider {
//         let data = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
//        @State  var selectedItemIdx = 0
////        static var previews: some View {
////            
////        }
////    }
    var body: some View {
        ZStack {
            TabView {
                DartsGameView()
                    .tabItem {
                        Label("viewTitle_Darts", systemImage: "gamecontroller")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                DartsGameResultsView()
                    .tabItem {
                        Label("viewTitle_Statistics", systemImage: "trophy")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                AppSettingsView()
                    .tabItem {
                        Label("viewTitle_AppSettings", systemImage: "gear")

                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
