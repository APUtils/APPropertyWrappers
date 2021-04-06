//
//  BoolPreserved.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 4/6/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

#if COCOAPODS
import LogsManager
#else
import RoutableLogger
#endif

/// Uses file existence to preserve flag. More robust than `@UserDefaul` because the
/// flag set is atomic and doesn't require synchronization.
///
///  Might be used just before possible app crash or exit to detect unsuccessfull starts for example.
@propertyWrapper
open class BoolPreserved {
    
    private static let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    
    /// By default file existense means `true` and absence is `false`
    /// but if `defaultValue` of `true` was passed we invert this behavior.
    private let invert: Bool
    
    private let path: String
    
    open var wrappedValue: Bool {
        get {
            if invert {
                return !FileManager.default.fileExists(atPath: path)
            } else {
                return FileManager.default.fileExists(atPath: path)
            }
        }
        set {
            if invert && newValue {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    RoutableLogger.logError("Unable to set BoolPreserved flag", error: error, data: ["path": path, "value": newValue, "documentsURL": Self.documentsURL])
                }
            } else {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        }
    }
    
    public init(key: String, defaultValue: Bool) {
        self.invert = defaultValue
        self.path = Self.documentsURL.appendingPathComponent("BoolPreserved_\(key)").path
    }
}

// ******************************* MARK: - Equatable

extension BoolPreserved: Equatable {
    public static func == (lhs: BoolPreserved, rhs: BoolPreserved) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
