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
    
    public typealias Transform = (String?) -> (String?)
    
    static let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    private let url: URL
    private let preserveDefault: Bool
    private let setTransform: Transform
    private let getTransform: Transform
    
    /// Storage that is used to prevent continuous object read from file and so to speedup property access.
    private var storage: String?
    private var defaultValue: String?
    
    open var wrappedValue: String? {
        get {
            storage
        }
        set {
            guard newValue != storage else { return }
            storage = newValue
            
            let value = setTransform(newValue)
            Self.setValue(value, url: url)
        }
    }
    
    public init(key: String,
                defaultValue: String? = nil,
                preserveDefault: Bool = false,
                setTransform: @escaping Transform = { $0 },
                getTransform: @escaping Transform = { $0 }) {
        
        self.url = Self.documentsURL.appendingPathComponent("FilePreserved_\(key)")
        self.preserveDefault = preserveDefault
        self.defaultValue = defaultValue
        self.setTransform = setTransform
        self.getTransform = getTransform
        
        if let value = Self.getValue(url: url) {
            self.storage = getTransform(value)
        } else {
            if preserveDefault {
                let value = setTransform(defaultValue)
                Self.setValue(value, url: url)
            }
            self.storage = defaultValue
        }
    }
    
    /// Resets value to its default by erasing related file.
    public func reset() {
        storage = defaultValue
        
        if preserveDefault {
            let value = setTransform(defaultValue)
            Self.setValue(value, url: url)
            return
        }
        
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            RoutableLogger.logError("Unable to reset preserved data", error: error, data: ["url": url])
        }
    }
    
    fileprivate static func getValue(url: URL) -> String? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            RoutableLogger.logError("Unable to get data from existing file. Preserved data was not restored.", error: error, data: ["url": url])
            return nil
        }
        
        if let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            RoutableLogger.logError("Unable to decode preserved data. Preserved data was not restored.", data: ["url": url, "data": data])
            return nil
        }
    }
    
    fileprivate static func setValue(_ value: String?, url: URL) {
        if let value {
            if let data = value.data(using: .utf8) {
                do {
                    try data.write(to: url)
                } catch {
                    RoutableLogger.logError("Unable to set new value. Data write failed.", error: error, data: ["url": url, "data": data])
                }
            } else {
                RoutableLogger.logError("Unable to set new value. Data conversion failed.", data: ["url": url])
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

// ******************************* MARK: - Equatable

extension FilePreserved: Equatable {
    public static func == (lhs: FilePreserved, rhs: FilePreserved) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
