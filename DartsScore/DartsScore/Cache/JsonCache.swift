//
//  JsonCache.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

enum DataStoreType: String {
    case json
}

final class JsonCache<T: Codable> {
    static func load(from name: String) throws -> T? {
        let jsonUrl = try getURL(with: name)
        let json = try String(contentsOf: jsonUrl, encoding: .utf8)
        
        if let jsonData = json.data(using: .utf8) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(T.self, from: jsonData)
        }
        
        return nil
    }
    
    static func save(_ context: T, to name: String) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        let jsonData = try encoder.encode(context)
        
        guard let json = String(data: jsonData, encoding: .utf8) else {
            throw DataCacheError.castingToDictionaryFailed
        }
        
        let fileURL = try getURL(with: name)
        try json.write(toFile: fileURL.path(), atomically: true, encoding: .utf8)
    }
    
    static func deleteFile(name: String) {
        guard let jsonFileUrl = try? getURL(with: name) else { return }
        
        do {
            try FileManager.default.removeItem(at: jsonFileUrl)
            print("Файл успешно удален.")
        } catch {
            print("Ошибка при удалении файла: \(error.localizedDescription)")
        }
    }
    
    private static func getURL(with name: String) throws -> URL {
        let fileManager = FileManager.default
        guard var fileURL = fileManager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first
        else { throw DataCacheError.notPassedDataURL }
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.createDirectory(atPath: fileURL.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                throw DataCacheError.folderCreatingFailed(path: fileURL.path,
                                                          error: error)
            }
        }
        
        fileURL.appendPathComponent(name)
        fileURL.appendPathExtension(DataStoreType.json.rawValue)
        
        return fileURL
    }
    
    private static func hasFile(with name: String) -> Bool {
        (try? getURL(with: name)) != nil
    }
}
