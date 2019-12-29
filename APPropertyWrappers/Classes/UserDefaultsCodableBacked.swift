//
//  UserDefaultsCodableBacked.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 12/13/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Property wrapper that stores codable value as data in UserDefaults.
@propertyWrapper
public struct UserDefaultsCodableBacked<V: Codable> {
    
    private let key: String
    private let defaultValue: V
    
    public var wrappedValue: V {
        get { return UserDefaults.standard.getCodableValue(type: V.self, forKey: key) ?? defaultValue }
        set { UserDefaults.standard.setCodableValue(type: V.self, value: newValue, forKey: key) }
    }
    
    /// Removes object from the UserDefaults
    public func removeFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    public init(key: String, defaultValue: V) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// ******************************* MARK: - Codable Support

private extension UserDefaults {
    /// - warning: It doesn't work with primitive types.
    func setCodableValue<T: Codable>(type: T.Type, value: T?, forKey key: String) {
        guard let value = value else {
            removeObject(forKey: key)
            return
        }
        
        guard let data = value.safePropertyListEncoded() else { return }
        
        set(data, forKey: key)
    }
    
    /// - warning: It doesn't work with primitive types.
    func getCodableValue<T: Codable>(type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return type.safeCreate(propertyListData: data)
    }
}

private extension Encodable {
    func safePropertyListEncoded() -> Data? {
        let encoder = PropertyListEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            print("Can not encode to property list data: \(error)")
            return nil
        }
    }
}

private extension Decodable {
    static func safeCreate(propertyListData: Data) -> Self? {
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode(Self.self, from: propertyListData)
        } catch {
            print("Can not decode from property list: \(error)")
            return nil
        }
    }
}
