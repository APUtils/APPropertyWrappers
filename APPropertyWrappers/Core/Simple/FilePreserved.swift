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
    private let setTransform: Transform
    private let getTransform: Transform
    
    /// Storage that is used to prevent continuous object read from file and so to speedup property access.
    private var storage: String?
    
    open var wrappedValue: String? {
        get {
            getTransform(storage)
        }
        set {
            let newValue = setTransform(newValue)
            guard newValue != storage else { return }
            
            storage = newValue
            if let newValue = newValue {
                if let data = newValue.data(using: .utf8) {
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
    
    public init(key: String,
                setTransform: @escaping Transform = { $0 },
                getTransform: @escaping Transform = { $0 }) {
        
        self.url = Self.documentsURL.appendingPathComponent("FilePreserved_\(key)")
        self.setTransform = setTransform
        self.getTransform = getTransform
        
        if FileManager.default.fileExists(atPath: url.path) {
            let data: Data
            do {
                data = try Data(contentsOf: url)
            } catch {
                RoutableLogger.logError("Unable to get data from existing file. Preserved data was not restored.", error: error, data: ["key": key, "url": url])
                return
            }
            
            if let string = String(data: data, encoding: .utf8) {
                storage = string
            } else {
                RoutableLogger.logError("Unable to decode preserved data. Preserved data was not restored.", data: ["key": key, "url": url, "data": data])
            }
            
        } else {
            storage = nil
        }
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
}

// ******************************* MARK: - Equatable

extension FilePreserved: Equatable {
    public static func == (lhs: FilePreserved, rhs: FilePreserved) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
