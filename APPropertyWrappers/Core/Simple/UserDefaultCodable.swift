//
//  UserDefaultCodable.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 12/13/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

/// Property wrapper that stores codable value as data in `UserDefaults`.
/// - Tag: UserDefaultCodable
@propertyWrapper
public final class UserDefaultCodable<V: Codable> {
    
    // ******************************* MARK: - Properties
    
    fileprivate let userDefaults: UserDefaults
    fileprivate let useStorage: Bool
    fileprivate let key: String
    @Lazy fileprivate var defaultValue: V
    
    /// Storage that is used to prevent continuous object decode and so to speedup property access.
    @Lazy fileprivate var storage: V
    
    public var wrappedValue: V {
        get {
            if useStorage {
                return storage
            } else {
                return Self.getValue(userDefaults: userDefaults, key: key, defaultValue: defaultValue)
            }
        }
        set {
            if useStorage {
                storage = newValue
            }
            
            do {
                try userDefaults.setCodableValue(type: Box.self, value: Box(value: newValue), forKey: key)
            } catch {
                RoutableLogger.logError("Unable to set codable value for UserDefaults", error: error, data: ["type": V.self, "value": newValue, "key": key, "defaultValue": defaultValue])
            }
        }
    }
    
    /// Removes object from the UserDefaults but preserves it in the storage
    public func removeFromUserDefaults() {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Resets preserved value to its default by removing value from `UserDefaults`
    public func reset() {
        if useStorage {
            _storage.projectedValue = _defaultValue.projectedValue
        }
        
        removeFromUserDefaults()
    }
    
    public convenience init(suitName: String? = nil,
                            useStorage: Bool = true,
                            key: String,
                            defaultValue: V,
                            file: String = #file,
                            function: String = #function,
                            line: UInt = #line) {
        
        self.init(suitName: suitName, useStorage: useStorage, key: key, defferedDefaultValue: defaultValue, file: file, function: function, line: line)
    }
    
    public init(suitName: String? = nil,
                useStorage: Bool = true,
                key: String,
                defferedDefaultValue: @escaping @autoclosure () -> V,
                file: String = #file,
                function: String = #function,
                line: UInt = #line) {
        
        GlobalFunctions.reportUserDefaultsDotKeyIfNeeded(key: key, file: file, function: function, line: line)
        
        let userDefaults: UserDefaults
        if let suitName = suitName {
            if let _userDefaults = UserDefaults(suiteName: suitName) {
                userDefaults = _userDefaults
            } else {
                RoutableLogger.logError("Unable to initialize user defaults", data: ["suitName": suitName])
                userDefaults = .standard
            }
        } else {
            userDefaults = .standard
        }
        self.userDefaults = userDefaults
        
        self.useStorage = useStorage
        self.key = key
        _defaultValue = Lazy(projectedValue: defferedDefaultValue())
        
        if useStorage {
            _storage = Lazy(projectedValue: { () -> V in
                Self.getValue(userDefaults: userDefaults, key: key, defaultValue: defferedDefaultValue())
            }())
        } else {
            _storage = Lazy(projectedValue: { () -> V in
                fatalError("Storage should not be used")
            }())
        }
    }
    
    static func getValue(userDefaults: UserDefaults, key: String, defaultValue: V) -> V {
        do {
            return try userDefaults.getCodableValue(type: Box.self, forKey: key)?.value ?? defaultValue
        } catch {
            RoutableLogger.logError("Unable to get codable value from UserDefaults", error: error, data: ["type": V.self, "key": key, "defaultValue": defaultValue])
            return defaultValue
        }
    }
}

// ******************************* MARK: - Convenience Inits

public extension UserDefaultCodable where V: ExpressibleByNilLiteral {
    convenience init(suitName: String? = nil,
                     useStorage: Bool = true,
                     key: String,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        
        self.init(suitName: suitName, useStorage: useStorage, key: key, defaultValue: nil, file: file, function: function, line: line)
    }
}

public extension UserDefaultCodable where V: ExpressibleByArrayLiteral {
    convenience init(suitName: String? = nil,
                     useStorage: Bool = true,
                     key: String,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        
        self.init(suitName: suitName, useStorage: useStorage, key: key, defaultValue: [], file: file, function: function, line: line)
    }
}

public extension UserDefaultCodable where V: ExpressibleByDictionaryLiteral {
    convenience init(suitName: String? = nil,
                     useStorage: Bool = true,
                     key: String,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        
        self.init(suitName: suitName, useStorage: useStorage, key: key, defaultValue: [:], file: file, function: function, line: line)
    }
}

// ******************************* MARK: - Equatable

extension UserDefaultCodable: Equatable where V: Equatable {
    public static func == (lhs: UserDefaultCodable<V>, rhs: UserDefaultCodable<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

// ******************************* MARK: - Codable Support

private extension UserDefaults {
    
    enum UserDefaultsError: Swift.Error {
        case primitiveTypeNotSupported
    }
    
    /// - warning: It doesn't work with primitive types.
    func setCodableValue<T: Codable>(type: T.Type, value: T?, forKey key: String) throws {
        
        if isPrimitiveType(type) {
            throw UserDefaultsError.primitiveTypeNotSupported
        }
        
        guard let value = value else {
            removeObject(forKey: key)
            return
        }
        
        let data = try value.propertyListEncoded()
        set(data, forKey: key)
    }
    
    /// - warning: It doesn't work with primitive types.
    func getCodableValue<T: Codable>(type: T.Type, forKey key: String) throws -> T? {
        
        if isPrimitiveType(type) {
            throw UserDefaultsError.primitiveTypeNotSupported
        }
        
        guard let data = data(forKey: key) else { return nil }
        
        do {
            return try type.create(propertyListData: data)
        } catch {
            RoutableLogger.logInfo("Erasing corrupted data for key: \(key)")
            removeObject(forKey: key)
            throw error
        }
    }
    
    func isPrimitiveType<T: Codable>(_ type: T.Type) -> Bool {
        
        #if os(iOS)
        if #available(macOS 11.0, iOSApplicationExtension 14.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *), type is Float16.Type {
            return true
        }
        #endif
        
        switch type {
        case is String.Type,
             is Float32.Type,
             is Float64.Type,
             is Float.Type,
             is Double.Type,
             is CGFloat.Type,
             is Int8.Type,
             is Int16.Type,
             is Int32.Type,
             is Int64.Type,
             is Int.Type:
            return true
            
        default: return false
        }
    }
}
