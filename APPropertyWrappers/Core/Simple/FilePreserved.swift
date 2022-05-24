//
//  FilePreserved.swift
//  Pods
//
//  Created by Anton Plebanovich on 24.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

/// Uses file to preserve string data.
@propertyWrapper
open class FilePreserved {
    
    private static let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    private let url: URL
    
    /// Storage that is used to prevent continuous object read from file and so to speedup property access.
    private var storage: String
    
    open var wrappedValue: String {
        get {
            storage
        }
        set {
            guard newValue != storage else { return }
            
            storage = newValue
            if let data = newValue.data(using: .utf8) {
                do {
                    try data.write(to: url)
                } catch {
                    RoutableLogger.logError("Unable to set new value. Data write failed.", error: error, data: ["url": url, "data": data, "documentsURL": Self.documentsURL])
                }
            } else {
                RoutableLogger.logError("Unable to set new value. Data conversion failed.", data: ["url": url, "documentsURL": Self.documentsURL])
            }
        }
    }
    
    public init(key: String, defaultValue: String) {
        self.url = Self.documentsURL.appendingPathComponent("FilePreserved_\(key)")
        
        if FileManager.default.fileExists(atPath: url.path) {
            let data: Data
            do {
                data = try Data(contentsOf: url)
            } catch {
                RoutableLogger.logError("Unable to get data from file. Falling back to default value.", error: error, data: ["key": key, "url": url, "documentsURL": Self.documentsURL])
                storage = defaultValue
                return
            }
            
            if let string = String(data: data, encoding: .utf8) {
                storage = string
            } else {
                RoutableLogger.logError("Unable to decode preserved data. Falling back to default value.", data: ["key": key, "url": url, "documentsURL": Self.documentsURL, "data": data])
                storage = defaultValue
            }
            
        } else {
            storage = defaultValue
            let data = defaultValue.data(using: .utf8)
            try? data?.write(to: url)
        }
    }
    
    /// Resets value to its default.
    public func reset() {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            RoutableLogger.logError("Unable to reset preserved data", error: error, data: ["url": url, "documentsURL": Self.documentsURL])
        }
    }
}

// ******************************* MARK: - Equatable

extension FilePreserved: Equatable {
    public static func == (lhs: FilePreserved, rhs: FilePreserved) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
