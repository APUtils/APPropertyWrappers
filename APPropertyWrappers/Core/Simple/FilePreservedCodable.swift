//
//  FilePreservedCodable.swift
//  Pods
//
//  Created by Anton Plebanovich on 5.09.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

/// Uses file to preserve string data.
@propertyWrapper
open class FilePreservedCodable<V: Codable & Equatable> {
    
    private let url: URL
    
    /// Storage that is used to prevent continuous object read from file and so to speedup property access.
    private var storage: V?
    
    open var wrappedValue: V? {
        get {
            storage
        }
        set {
            guard newValue != storage else { return }
            
            storage = newValue
            if let newValue = newValue {
                let boxedValue = Box(value: newValue)
                let data: Data
                do {
                    data = try boxedValue.propertyListEncoded()
                } catch {
                    RoutableLogger.logError("Unable to set new value. Data conversion failed.", data: ["url": url])
                    return
                }
                
                do {
                    try data.write(to: url)
                } catch {
                    RoutableLogger.logError("Unable to set new value. Data write failed.", error: error, data: ["url": url, "data": data])
                }
                    
            } else {
                if FileManager.default.fileExists(atPath: url.path) {
                    do {
                        try FileManager.default.removeItem(at: url)
                    } catch {
                        RoutableLogger.logError("Unable to remove existing file. Preserved data was not removed.", error: error, data: ["url": url])
                    }
                }
            }
        }
    }
    
    public init(key: String) {
        self.url = FilePreserved.documentsURL.appendingPathComponent("FilePreservedCodable_\(key)")
        self.storage = Self.getValue(url: url)
    }
    
    /// Resets value to its default.
    public func reset() {
        do {
            try FileManager.default.removeItem(at: url)
            storage = nil
        } catch {
            RoutableLogger.logError("Unable to reset preserved data", error: error, data: ["url": url])
        }
    }
    
    static func getValue(url: URL) -> V? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            RoutableLogger.logError("Unable to get data from existing file. Preserved data was not restored.", error: error, data: ["url": url])
            return nil
        }
        
        do {
            return try Box<V>.create(propertyListData: data).value
        } catch {
            RoutableLogger.logError("Unable to decode preserved data. Preserved data was not restored.", data: ["url": url, "data": data])
            return nil
        }
    }
}

// ******************************* MARK: - Equatable

extension FilePreservedCodable: Equatable {
    public static func == (lhs: FilePreservedCodable, rhs: FilePreservedCodable) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
