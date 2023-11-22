//
//  DataCacheError.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

enum DataCacheError: LocalizedError {
    // json errors
    case jsonSerializationFailed(error: Error)
    case jsonDeserializationFailed(error: Error)
    case castingToDictionaryFailed
    case jsonObjectParsingFailed(path: String, count: Int)
    
    // URL errors
    case notPassedDataURL
    case notExistsFile(path: String)
    case folderCreatingFailed(path: String, error: Error)
    
    // saving errors
    case jsonWritingToFileFailed(path: String, error: Error)
    
    // loading errors
    case jsonReadingFromFileFailed(path: String, error: Error)
    
    case systemError(error: Error)
    
    var errorDescription: String? {
        switch self {
        // json errors
        case .jsonSerializationFailed(let error):
            return "Error serializing object with type [Any] to JSON Data!" +
                "\n  \(error.localizedDescription)"
        case .jsonDeserializationFailed(let error):
            return "Error deserializing Data (JSON) into an object with type [Any]!" +
                "\n  \(error.localizedDescription)"
        case .castingToDictionaryFailed:
            return "Error casting data from type [Any] to type [[String: Any]]!"
        case .jsonObjectParsingFailed(let path, let count):
            return "Failed to parse \(count) objects from a JSON object obtained from the path: \(path)"
            
        // URL errors
        case .notPassedDataURL:
            return "No URL was passed to save/read the file!"
        case .notExistsFile(let path):
            return "File path does not exist: \(path)"
        case .folderCreatingFailed(let path, let error):
            return "Error creating a directory in the file system along the path: \(path)" +
                "\n  \(error.localizedDescription)"
            
        // saving errors
        case .jsonWritingToFileFailed(let path, let error):
            return "Error writing JSON data to file path: \(path)" +
                "\n  \(error.localizedDescription)"
            
        // loading errors
        case .jsonReadingFromFileFailed(let path, let error):
            return "Error reading data from JSON file path: \(path)" +
                "\n  \(error.localizedDescription)"
            
        case .systemError(let error):
            return "A system exception was thrown! \n  \n  \(error)"
        }
    }
}
