//
//  UserDefaultsBacked.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 12/13/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Property wrapper that stores value as an object in UserDefaults.
@propertyWrapper
public struct UserDefaultsBacked<V> {
    
    private let key: String
    private let defaultValue: V
    
    public var wrappedValue: V {
        get { return UserDefaults.standard.object(forKey: key) as? V ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
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
