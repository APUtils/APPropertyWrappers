//
//  UserDefault.swift
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

/// Property wrapper that stores value as an object in UserDefaults.
@propertyWrapper
open class UserDefault<V> {
    
    private let userDefaults: UserDefaults
    private let key: String
    @Lazy private var defferedDefaultValue: V
    
    open var wrappedValue: V {
        get { return userDefaults.object(forKey: key) as? V ?? defferedDefaultValue }
        set { userDefaults.set(newValue, forKey: key) }
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
                RoutableLogger.logError("Unable to initialize user defaults", data: ["suitName": suitName])
                self.userDefaults = UserDefaults.standard
            }
        } else {
            self.userDefaults = UserDefaults.standard
        }
        
        self.key = key
        self._defferedDefaultValue = Lazy(projectedValue: defferedDefaultValue())
    }
}

// ******************************* MARK: - Convenience Inits

public extension UserDefault where V: ExpressibleByNilLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: nil)
    }
}

public extension UserDefault where V: ExpressibleByArrayLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [])
    }
}

public extension UserDefault where V: ExpressibleByDictionaryLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [:])
    }
}
