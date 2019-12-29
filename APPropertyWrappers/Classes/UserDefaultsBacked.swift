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
    
    private let userDefaults: UserDefaults
    private let key: String
    private let defaultValue: V
    
    public var wrappedValue: V {
        get { return userDefaults.object(forKey: key) as? V ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key) }
    }
    
    /// Removes object from the UserDefaults
    public func removeFromUserDefaults() {
        userDefaults.removeObject(forKey: key)
    }
    
    public init(suitName: String? = nil, key: String, defaultValue: V) {
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
        self.defaultValue = defaultValue
    }
}
