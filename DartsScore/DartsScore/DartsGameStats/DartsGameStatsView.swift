//
//  DartsGameStatsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

class DartsGameStatsViewModel: ObservableObject {
    @Published private(set) var model: DartsGameStats = .init()
    
    init() {
        refresh()
    }
    
    func refresh() {
        model = (try? JsonCache<DartsGameStats>.load(from: AppSettings.statsJsonFileName))
        ?? MockData.getDartsGameStats()
//        model = MockData.getDartsGameStats()
    }
}

struct DartsGameStatsView: View {
    @State private var path = NavigationPath()
    @ObservedObject var statsVM: DartsGameStatsViewModel
    
    init(statsVM: DartsGameStatsViewModel = .init()) {
        self.statsVM = statsVM
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    HStack {
                        Text("Очки")
                            .bold()
                            .frame(maxWidth: .infinity)
                        Text("Попытки")
                            .frame(maxWidth: .infinity)
                        Text("Время")
                            .frame(maxWidth: .infinity)
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 32)
                    
                    ForEach(statsVM.model.items) { game in
                        Button(action: {
                            path.append(game.id)
                        }, label: {
                            HStack {
                                Text(String(game.score))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                Text("\(game.successCount)/\(game.attempts)")
                                    .frame(maxWidth: .infinity)
                                Text("\(game.timeForAnswer) сек.")
                                    .frame(maxWidth: .infinity)
                                Image(systemName: "chevron.right")
                            }
                        })
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 4)
                    }
                }.frame(maxWidth: .infinity)
                
//                VStack {
//                    HStack {
//                        Text("Очки")
//                        Spacer()
//                        Text("Попытки")
//                        Spacer()
//                        Text("Время на ответ")
//                    }
//                    .padding(.horizontal, 32)
                    
//                    Table(statsVM.model.items) {
//                        TableColumn("Очки") { item in
//                            Text(String(item.score))
//                        }
//                        TableColumn("Очки2") { item in
//                            Text(String(item.attempts))
//                        }
//                    }
//                    Table(statsVM.model.items) {
////                        TableColumn("Очки") { item in
////                            Text(String(item.score))
////                        }
//                        
//                        TableColumn("Попытки") { item2 in
//                            Text("\(item2.successCount)")
//                        }
//                    }
//                    List(statsVM.model.items) { gameStats in
//                        HStack {
//                            Text(String(gameStats.score))
//                            Spacer()
//                            Text("\(gameStats.successCount)/\(gameStats.attempts)")
//                            Spacer()
//                            Spacer()
//                            Text("\(gameStats.timeForAnswer) сек.")
//                        }
//                    }
//                }
                .onAppear {
                    statsVM.refresh()
                }
            }
            .navigationTitle("Статистика")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { gameIdx in
                if let game = getGame(gameIdx) {
                    GameAnswersView(game)
                }
//                if view == "NewView" {
//                    Text("This is NewView")
//                }
            }
        }
    }
    
    private func getGame(_ idx: String) -> DartsGame? {
        statsVM.model.items.first { $0.id == idx }
    }
}

#Preview {
    NavigationStack {
        DartsGameStatsView()
    }
}

struct MockData {
    
    static func getDartsGameStats() -> DartsGameStats {
        .init(
            createdOn: .now,
            updatedOn: .now,
            items: [
                .init(
                    attempts: 10,
                    timeForAnswer: 60,
                    successCount: 4,
                    score: 218,
                    answers: [
                        .init(
                            expected: 46,
                            actual: 113,
                            answers: [100, 171, 113, 46, 131],
                            darts: [
                                .init(
                                    for: .init(x: -74.68731142673033, y: 7.5668327770026425),
                                    in: .init(points: 11, xScore: 3)
                                ),
                                .init(
                                    for: .init(x: -114.41818603506827, y: -121.26699838960911),
                                    in: .init(.outOfPoints)
                                ),
                                .init(
                                    for: .init(x: 47.69048522948828, y: 10.236433758896286),
                                    in: .init(points: 13, xScore: 1)
                                )
                            ], 
                            time: 1100,
                            score: 0
                        )
                    ],
                    remainingTimeForAnswer: 0
                ),
                .init(
                    attempts: 10,
                    timeForAnswer: 60,
                    successCount: 4,
                    score: 218,
                    answers: [],
                    remainingTimeForAnswer: 0
                )
            ]
        )
    }
//              ▿ darts : 3 elements
//                ▿ 2 : Dart:
//      position: (x: 47.69; y: 10.24)
//      sector: 13x1
//                  - id : "290FE5BE-0FAF-4613-A6AF-47210482F06F"
//                  ▿ position : (47.69048522948828, 10.236433758896286)
//                    - x : 47.69048522948828
//                    - y : 10.236433758896286
//                  ▿ sector : 13x1
//                    - points : 13
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//              - time : 1100
//              - score : 0
//            ▿ 2 : AnswerSnapshot
//              - id : "DD00F912-2E0A-42F4-971C-BBD20A3A79AD"
//              - expected : 11
//              - actual : 7
//              ▿ answers : 5 elements
//                - 0 : 11
//                - 1 : 24
//                - 2 : 7
//                - 3 : 41
//                - 4 : 78
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: 89.37; y: -126.87)
//      sector: Out of Points
//                  - id : "451D37AF-EA79-4E5E-BC33-0C674BD43676"
//                  ▿ position : (89.37155555788614, -126.87117994772751)
//                    - x : 89.37155555788614
//                    - y : -126.87117994772751
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//                ▿ 1 : Dart:
//      position: (x: 16.08; y: 74.28)
//      sector: 1x3
//                  - id : "FCDF01AD-B16A-409B-B69D-250DE914D9BB"
//                  ▿ position : (16.07532065426242, 74.27731754445185)
//                    - x : 16.07532065426242
//                    - y : 74.27731754445185
//                  ▿ sector : 1x3
//                    - points : 1
//                    - xScore : 3
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 2 : Dart:
//      position: (x: -82.89; y: -23.20)
//      sector: 8x1
//                  - id : "12317D7C-26B9-4C95-BB82-A0FFA24B566E"
//                  ▿ position : (-82.89081190946936, -23.204907107753257)
//                    - x : -82.89081190946936
//                    - y : -23.204907107753257
//                  ▿ sector : 8x1
//                    - points : 8
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//              - time : 1000
//              - score : 0
//            ▿ 3 : AnswerSnapshot
//              - id : "13FEBB16-A281-4167-B55D-BC02AC732FF7"
//              - expected : 12
//              - actual : 7
//              ▿ answers : 5 elements
//                - 0 : 68
//                - 1 : 76
//                - 2 : 7
//                - 3 : 12
//                - 4 : 69
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: -30.02; y: 82.56)
//      sector: 5x1
//                  - id : "6B4A2645-322A-4EF5-8624-E3C20ED6A0FF"
//                  ▿ position : (-30.021903518052397, 82.55773697615189)
//                    - x : -30.021903518052397
//                    - y : 82.55773697615189
//                  ▿ sector : 5x1
//                    - points : 5
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 1 : Dart:
//      position: (x: 37.63; y: -56.05)
//      sector: 2x1
//                  - id : "86299970-ECBE-4088-A09D-8F87FDCCA2D5"
//                  ▿ position : (37.627094465887225, -56.0477052992337)
//                    - x : 37.627094465887225
//                    - y : -56.0477052992337
//                  ▿ sector : 2x1
//                    - points : 2
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 2 : Dart:
//      position: (x: -13.45; y: 50.68)
//      sector: 5x1
//                  - id : "4B5981B0-1353-4580-8F4F-15865983F949"
//                  ▿ position : (-13.448697803620123, 50.676660652923644)
//                    - x : -13.448697803620123
//                    - y : 50.676660652923644
//                  ▿ sector : 5x1
//                    - points : 5
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//              - time : 1000
//              - score : 0
//            ▿ 4 : AnswerSnapshot
//              - id : "0BE828FF-97F2-4292-A14F-0148DCB3CDFD"
//              - expected : 57
//              - actual : 57
//              ▿ answers : 5 elements
//                - 0 : 4
//                - 1 : 27
//                - 2 : 57
//                - 3 : 166
//                - 4 : 61
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: -113.00; y: 49.58)
//      sector: 14x2
//                  - id : "23F3D07A-2B0D-4397-9C90-9A9181B06E10"
//                  ▿ position : (-112.99518337758805, 49.58186017870711)
//                    - x : -112.99518337758805
//                    - y : 49.58186017870711
//                  ▿ sector : 14x2
//                    - points : 14
//                    - xScore : 2
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 1 : Dart:
//      position: (x: -54.74; y: -1.41)
//      sector: 11x1
//                  - id : "5766EFE6-DEA2-460F-A4CA-2AABDBE31F43"
//                  ▿ position : (-54.74240928394898, -1.4117007953131555)
//                    - x : -54.74240928394898
//                    - y : -1.4117007953131555
//                  ▿ sector : 11x1
//                    - points : 11
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 2 : Dart:
//      position: (x: 25.09; y: 36.90)
//      sector: 18x1
//                  - id : "9EE06F66-9469-4CF7-ADD8-C24912B0A5E5"
//                  ▿ position : (25.090263003953215, 36.904254517419105)
//                    - x : 25.090263003953215
//                    - y : 36.904254517419105
//                  ▿ sector : 18x1
//                    - points : 18
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//              - time : 1100
//              - score : 54
//            ▿ 5 : AnswerSnapshot
//              - id : "2406314F-AC89-4C7B-ACE4-BF3CCA2AED17"
//              - expected : 15
//              - actual : 15
//              ▿ answers : 5 elements
//                - 0 : 57
//                - 1 : 70
//                - 2 : 15
//                - 3 : 116
//                - 4 : 133
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: 94.14; y: -64.57)
//      sector: 15x1
//                  - id : "7CC4455F-AE24-4DAA-9498-1800251D99A4"
//                  ▿ position : (94.14135772798903, -64.57169465266826)
//                    - x : 94.14135772798903
//                    - y : -64.57169465266826
//                  ▿ sector : 15x1
//                    - points : 15
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 1 : Dart:
//      position: (x: -149.52; y: 40.99)
//      sector: Out of Points
//                  - id : "C8483784-A406-4249-AAF4-16268D72B6B7"
//                  ▿ position : (-149.52420955700424, 40.99072687411474)
//                    - x : -149.52420955700424
//                    - y : 40.99072687411474
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//                ▿ 2 : Dart:
//      position: (x: 11.26; y: -156.04)
//      sector: Out of Points
//                  - id : "E15375A5-EE89-49C1-8946-A6C4D5D3DA8B"
//                  ▿ position : (11.256436524063927, -156.04280011858552)
//                    - x : 11.256436524063927
//                    - y : -156.04280011858552
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//              - time : 1200
//              - score : 50
//            ▿ 6 : AnswerSnapshot
//              - id : "C36E7F15-D263-4C41-ADF6-6D782CCA0545"
//              - expected : 29
//              - actual : 29
//              ▿ answers : 5 elements
//                - 0 : 8
//                - 1 : 54
//                - 2 : 29
//                - 3 : 41
//                - 4 : 10
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: 23.18; y: -52.50)
//      sector: 17x1
//                  - id : "86BDF328-9D8C-4DA5-A91C-23C6A95CBF1F"
//                  ▿ position : (23.176446388556904, -52.50249463453436)
//                    - x : 23.176446388556904
//                    - y : -52.50249463453436
//                  ▿ sector : 17x1
//                    - points : 17
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 1 : Dart:
//      position: (x: 126.25; y: 17.47)
//      sector: 6x2
//                  - id : "78138522-D040-4436-B2C4-2FF5F4A425F2"
//                  ▿ position : (126.25489154503919, 17.469098470594957)
//                    - x : 126.25489154503919
//                    - y : 17.469098470594957
//                  ▿ sector : 6x2
//                    - points : 6
//                    - xScore : 2
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 2 : Dart:
//      position: (x: -141.49; y: 23.01)
//      sector: Out of Points
//                  - id : "8539CC97-D26E-4F7F-8D79-CE6CF84E6D07"
//                  ▿ position : (-141.48832971194224, 23.00751008176606)
//                    - x : -141.48832971194224
//                    - y : 23.00751008176606
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//              - time : 1100
//              - score : 54
//            ▿ 7 : AnswerSnapshot
//              - id : "E2B3F503-D746-4063-B275-722490405303"
//              - expected : 3
//              - actual : 44
//              ▿ answers : 5 elements
//                - 0 : 157
//                - 1 : 99
//                - 2 : 44
//                - 3 : 3
//                - 4 : 5
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: -3.97; y: -45.68)
//      sector: 3x1
//                  - id : "2676F682-3094-44F1-B7C6-1B349812E415"
//                  ▿ position : (-3.9662046059468476, -45.68370217416871)
//                    - x : -3.9662046059468476
//                    - y : -45.68370217416871
//                  ▿ sector : 3x1
//                    - points : 3
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 1 : Dart:
//      position: (x: 151.86; y: -71.60)
//      sector: Out of Points
//                  - id : "4AAD29DF-3B59-42E3-8DD3-DBFC83322FF9"
//                  ▿ position : (151.86276713042895, -71.60355525706746)
//                    - x : 151.86276713042895
//                    - y : -71.60355525706746
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//                ▿ 2 : Dart:
//      position: (x: 5.85; y: 160.26)
//      sector: Out of Points
//                  - id : "B6BCCD1F-30D1-4147-8DFA-7CA13D868815"
//                  ▿ position : (5.8505049309869515, 160.2641317382533)
//                    - x : 5.8505049309869515
//                    - y : 160.2641317382533
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//              - time : 1200
//              - score : 0
//            ▿ 8 : AnswerSnapshot
//              - id : "CD544807-A887-4F2B-8333-B81451FE2782"
//              - expected : 28
//              - actual : 25
//              ▿ answers : 5 elements
//                - 0 : 148
//                - 1 : 0
//                - 2 : 25
//                - 3 : 28
//                - 4 : 76
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: 31.19; y: 156.02)
//      sector: Out of Points
//                  - id : "B66C7DAA-CBD3-4C3A-9290-358BC94AEA2B"
//                  ▿ position : (31.1904136663305, 156.0157420217782)
//                    - x : 31.1904136663305
//                    - y : 156.0157420217782
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//                ▿ 1 : Dart:
//      position: (x: 82.81; y: -38.08)
//      sector: 10x1
//                  - id : "2E242BD0-7484-42D8-ACD7-00238233C7FB"
//                  ▿ position : (82.8111718552013, -38.08382504884968)
//                    - x : 82.8111718552013
//                    - y : -38.08382504884968
//                  ▿ sector : 10x1
//                    - points : 10
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//                ▿ 2 : Dart:
//      position: (x: -99.31; y: 75.12)
//      sector: 9x2
//                  - id : "1F7EBB93-3981-463C-8888-456863A7278B"
//                  ▿ position : (-99.31414206378048, 75.12325817171433)
//                    - x : -99.31414206378048
//                    - y : 75.12325817171433
//                  ▿ sector : 9x2
//                    - points : 9
//                    - xScore : 2
//                    - area : DartsScore.DartsSectorArea.points
//              - time : 1200
//              - score : 0
//            ▿ 9 : AnswerSnapshot
//              - id : "23EF94E6-8B4B-47DC-82A9-584AA4B72B3B"
//              - expected : 36
//              - actual : 171
//              ▿ answers : 5 elements
//                - 0 : 36
//                - 1 : 44
//                - 2 : 171
//                - 3 : 15
//                - 4 : 11
//              ▿ darts : 3 elements
//                ▿ 0 : Dart:
//      position: (x: -9.05; y: -2.67)
//      sector: 25 Points
//                  - id : "30848D60-F3A8-4F5E-9188-05BF74C5ED6B"
//                  ▿ position : (-9.05171622265738, -2.6746197536407235)
//                    - x : -9.05171622265738
//                    - y : -2.6746197536407235
//                  ▿ sector : 25 Points
//                    - points : 25
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points25
//                ▿ 1 : Dart:
//      position: (x: 166.06; y: -51.70)
//      sector: Out of Points
//                  - id : "A8BA43A5-FEF5-4595-942C-445624E3FB64"
//                  ▿ position : (166.06220201245333, -51.69808969444719)
//                    - x : 166.06220201245333
//                    - y : -51.69808969444719
//                  ▿ sector : Out of Points
//                    - points : 0
//                    - xScore : 0
//                    - area : DartsScore.DartsSectorArea.outOfPoints
//                ▿ 2 : Dart:
//      position: (x: -40.94; y: 1.74)
//      sector: 11x1
//                  - id : "41D167E5-7DA2-4CA0-8E7B-C23AC3F3809B"
//                  ▿ position : (-40.94205725790246, 1.739721033069799)
//                    - x : -40.94205725790246
//                    - y : 1.739721033069799
//                  ▿ sector : 11x1
//                    - points : 11
//                    - xScore : 1
//                    - area : DartsScore.DartsSectorArea.points
//              - time : 1100
//              - score : 0
//          - remainingTimeForAnswer : 0

}
