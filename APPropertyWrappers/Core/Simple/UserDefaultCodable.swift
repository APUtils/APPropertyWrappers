//
//  UserDefaultCodable.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 12/13/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

#if COCOAPODS
import LogsManager
#else
import RoutableLogger
#endif

/// Property wrapper that stores codable value as data in UserDefaults.
@propertyWrapper
open class UserDefaultCodable<V: Codable> {
    
    // ******************************* MARK: - Box
    
    public struct Box: Codable {
        let value: V
    }
    
    // ******************************* MARK: - Properties
    
    private let userDefaults: UserDefaults
    private let key: String
    @Lazy private var defferedDefaultValue: V
    
    /// Storage that is used to prevent continuous object decode and so to speedup property access.
    @Lazy private var storage: V
    
    open var wrappedValue: V {
        get {
            storage
        }
        set {
            storage = newValue
            do {
                try UserDefaults.standard.setCodableValue(type: Box.self, value: Box(value: newValue), forKey: key)
            } catch {
                logError("Unable to set codable value for UserDefaults", error: error, data: ["type": V.self, "value": newValue, "key": key, "defaultValue": defferedDefaultValue])
            }
        }
    }
    
    /// Removes object from the UserDefaults
    open func removeFromUserDefaults() {
        userDefaults.removeObject(forKey: key)
    }
    
    public convenience init(suitName: String? = nil, key: String, defaultValue: V) {
        self.init(suitName: suitName, key: key, defferedDefaultValue: defaultValue)
    }
    
    public init(suitName: String? = nil, key: String, defferedDefaultValue: @escaping @autoclosure () -> V) {
        if let suitName = suitName {
            if let userDefaults = UserDefaults(suiteName: suitName) {
                self.userDefaults = userDefaults
            } else {
                logError("Unable to initialize user defaults", data: ["suitName": suitName])
                self.userDefaults = UserDefaults.standard
            }
        } else {
            self.userDefaults = UserDefaults.standard
        }
        
        self.key = key
        self._defferedDefaultValue = Lazy(lazyValue: defferedDefaultValue())
        
        self._storage = Lazy(lazyValue: { () -> V in
            do {
                return try UserDefaults.standard.getCodableValue(type: Box.self, forKey: key)?.value ?? defferedDefaultValue()
            } catch {
                logError("Unable to get codable value from UserDefaults", error: error, data: ["type": V.self, "key": key, "defaultValue": defferedDefaultValue])
                return defferedDefaultValue()
            }
        }())
    }
}

// ******************************* MARK: - Convenience Inits

public extension UserDefaultCodable where V: ExpressibleByNilLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: nil)
    }
}

public extension UserDefaultCodable where V: ExpressibleByArrayLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [])
    }
}

public extension UserDefaultCodable where V: ExpressibleByDictionaryLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [:])
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
            logInfo("Erasing corrupted data for key: \(key)")
            removeObject(forKey: key)
            throw error
        }
    }
    
    func isPrimitiveType<T: Codable>(_ type: T.Type) -> Bool {
        
        if #available(iOSApplicationExtension 14.0, iOS 14.0, *), type is Float16.Type {
            return true
        }
        
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

private extension Encodable {
    
    /// Encodes the object into a property list.
    func propertyListEncoded() throws -> Data {
        let encoder = PropertyListEncoder()
        return try encoder.encode(self)
    }
}

private extension Decodable {
    
    /// Creates object from property list data.
    static func create(propertyListData: Data) throws -> Self {
        let decoder = PropertyListDecoder()
        return try decoder.decode(Self.self, from: propertyListData)
    }
}
