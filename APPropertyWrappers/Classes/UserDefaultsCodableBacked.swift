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
open class UserDefaultsCodableBacked<V: Codable> {
    
    private let userDefaults: UserDefaults
    private let key: String
    @Lazy private var defferedDefaultValue: V
    
    open var wrappedValue: V {
        get { return userDefaults.getCodableValue(type: V.self, forKey: key) ?? defferedDefaultValue }
        set { userDefaults.setCodableValue(type: V.self, value: newValue, forKey: key) }
    }
    
    /// Removes object from the UserDefaults
    open func removeFromUserDefaults() {
        userDefaults.removeObject(forKey: key)
    }
    
    convenience init(suitName: String? = nil, key: String, defaultValue: V) {
        self.init(suitName: suitName, key: key, defferedDefaultValue: defaultValue)
    }
    
    public init(suitName: String? = nil, key: String, defferedDefaultValue: @escaping @autoclosure () -> V) {
        if let suitName = suitName {
            if let userDefaults = UserDefaults(suiteName: suitName) {
                self.userDefaults = userDefaults
            } else {
                print("Unable to initialize user defaults with provided suite: \(suitName)")
                self.userDefaults = UserDefaults.standard
            }
        } else {
            self.userDefaults = UserDefaults.standard
        }
        
        self.key = key
        self._defferedDefaultValue = Lazy(lazyValue: defferedDefaultValue())
    }
}

// ******************************* MARK: - Convenience Inits

extension UserDefaultsCodableBacked where V: ExpressibleByNilLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: nil)
    }
}

extension UserDefaultsCodableBacked where V: ExpressibleByArrayLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [])
    }
}

extension UserDefaultsCodableBacked where V: ExpressibleByDictionaryLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [:])
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
