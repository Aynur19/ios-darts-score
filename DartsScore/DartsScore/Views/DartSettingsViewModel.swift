////
////  DartSettingsViewModel.swift
////  DartsScore
////
////  Created by Aynur Nasybullin on 09.12.2023.
////
//
//import SwiftUI
//
//struct DartSettings {
//    fileprivate static let jsonFileName = "DartSettings"
//    static let dartImageNamesData = [
//        "xmark", "plus", "staroflife.fill"
//    ]
//    
//    fileprivate static let defaultImageNameIdx = 0
//    fileprivate static let defaultImageName = dartImageNamesData[defaultImageNameIdx]
//    fileprivate static let defaultSize: CGFloat = 16
//    fileprivate static let defaultColor: Color = .blue
//    
//    fileprivate(set) var imageName: String
//    fileprivate(set) var size: CGFloat
//    fileprivate(set) var color: Color
//    
//    init() {
//        imageName = Self.defaultImageName
//        size = Self.defaultSize
//        color = Self.defaultColor
//    }
//}
//
//extension DartSettings: Codable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.imageName  = try container.decode(String.self, forKey: .imageName)
//        self.size       = try container.decode(CGFloat.self, forKey: .size)
//        self.color      = try container.decode(Color.self, forKey: .color)
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case imageName
//        case size
//        case color
//    }
//}
//
//final class DartSettingsViewModel: ObservableObject {
//    private var model: DartSettings
//
//    @Published private(set) var isChanged = false
//    
//    @Published var dartImageNameIdx: Int {
//        didSet { dartImageName = DartSettings.dartImageNamesData[dartImageNameIdx] }
//    }
//    
//    @Published private(set) var dartImageName: String {
//        didSet { checkChanges() }
//    }
//    
//    @Published var dartSize: CGFloat {
//        didSet { checkChanges() }
//    }
//    
//    @Published var dartColor: Color {
//        didSet { checkChanges() }
//    }
//    
//    init(_ model: DartSettings = .init()) {
//        print("\n==========================================")
//        print("DartSettingsViewModel.\(#function)")
//        
//        self.model = model
//        
//        dartImageNameIdx    = Self.getDartImageNameIdx(model)
//        dartImageName       = model.imageName
//        dartSize            = model.size
//        dartColor           = model.color
//    }
//    
//    func resetSettings() {
//        dartImageNameIdx    = Self.getDartImageNameIdx(model)
//        dartImageName       = model.imageName
//        dartSize            = model.size
//        dartColor           = model.color
//        
//        checkChanges()
//    }
//    
//    func saveSettings() {
//        model.imageName = dartImageName
//        model.size      = dartSize
//        model.color     = dartColor
//        
//        try? JsonCache.save(model, to: DartSettings.jsonFileName)
//        checkChanges()
//    }
//    
//    func checkChanges() {
//        isChanged = dartImageName != model.imageName
//    }
//    
//    private static func getDartImageNameIdx(_ model: DartSettings) -> Int {
//        guard let idx = DartSettings.dartImageNamesData.firstIndex(of: model.imageName) else {
//            return DartSettings.defaultImageNameIdx
//        }
//        
//        return idx
//    }
//}
