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
    
    /// Storage that is used to prevent continuous object decode and so to speedup property access.
    @Lazy private var storage: V
    
    open var wrappedValue: V {
        get {
            storage
        }
        set {
            storage = newValue
            if (newValue as AnyObject) is NSNull {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
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
        
        self.key = key
        self._defferedDefaultValue = Lazy(projectedValue: defferedDefaultValue())
        
        
        self._storage = Lazy(projectedValue: { () -> V in
            userDefaults.object(forKey: key) as? V ?? defferedDefaultValue()
        }())
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
