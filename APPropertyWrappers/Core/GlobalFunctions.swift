//
//  GlobalFunctions.swift
//  Pods
//
//  Created by Anton Plebanovich on 27.07.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RoutableLogger

enum GlobalFunctions {
    
    static func reportUserDefaultsDotKeyIfNeeded(key: String, file: String, function: String, line: UInt) {
        guard key.contains(".") else { return }
        
        RoutableLogger.logWarning("[\(String._getFileName(filePath: file)):\(line)] Please use '_' instead of '.' for `key` value. This will allow to observe the value later if needed. '.' is considered as key path instead of part of a key in observation methods.")
    }
}

fileprivate extension String {
    /// Helper method to get filename from `file` parameter that is a file path.
    /// - parameters:
    ///   - filePath: File path that is passed through `#file` compile directrive as default parameter.
    static func _getFileName(filePath: String) -> String {
        guard let lastPathComponent = filePath.components(separatedBy: "/").last else { return "" }
        
        var components = lastPathComponent.components(separatedBy: ".")
        if components.count == 1 {
            return lastPathComponent
        } else {
            components.removeLast()
            return components.joined(separator: ".")
        }
    }
}
